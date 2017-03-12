#!/usr/bin/env python
# coding: utf-8

import collections
import functools
import json
import logging
import os
import tarfile

try:
    from urllib import urlretrieve
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlretrieve, urlopen

logger = logging.getLogger('dot')

SEPARATOR = '_'
VIM_ROOT = os.path.dirname(os.path.abspath(__file__))
VIM_HOME = os.path.join(os.path.expanduser('~'), '.vim')


def ignore_errors(func, errors=Exception, with_logging=True, level='warning'):
    log_func = getattr(logger, level)
    errors = tuple(errors) if hasattr(errors, '__iter__') else errors

    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except errors as e:
            if with_logging:
                log_func('run func "%s": caught exception %s: %s',
                         func.__name__, type(e).__name__, e)

    return wrapper


def init_logging(verbose=0):
    log_level = int(logging.WARNING - verbose * 10)
    log_format = '%(asctime)s [%(levelname)s] ' \
                 '[%(name)s::%(funcName)s:%(lineno)d]: %(message)s'
    logging.basicConfig(format=log_format, level=log_level)

    for attr, lvl_str in [('DEBUG', 'DBG'), ('INFO', 'INF'), ('ERROR', 'ERR'),
                          ('WARNING', 'WRN'), ('CRITICAL', 'CRT')]:
        logging.addLevelName(getattr(logging, attr), lvl_str)


def extract_tags(repo_url):
    api_url = repo_url.replace('/github.com/', '/api.github.com/repos/')
    tags_url = os.path.join(api_url, 'tags')
    tags = json.loads(urlopen(tags_url).read())
    Tag = collections.namedtuple('Tag', 'name, tarball, zipball')
    return (Tag(t['name'], t['tarball_url'], t['zipball_url']) for t in tags)


def update_repo(repo_name, repo_url, vendor_dir, check_tag=lambda _: True,
                dry_run=False):

    def extract_tag(filename):
        tag = filename.split(SEPARATOR)[-1]
        while any(tag.endswith(ext) for ext in ('.gz', '.tar', '.zip')):
            tag, _ = os.path.splitext(tag)
        return tag

    saved_tags = {extract_tag(name) for name in os.listdir(vendor_dir)
                  if name.startswith(repo_name)}
    logging.debug('saved tags for repo %s: %s', repo_name, saved_tags)

    for tag in (t for t in extract_tags(repo_url) if check_tag(t.name)):
        assert_msg = 'tag name "{}" contains {}'.format(tag.name, SEPARATOR)
        assert SEPARATOR not in tag.name, assert_msg

        dst_name = '{}{}{}.tar.gz'.format(repo_name, SEPARATOR, tag.name)
        path = os.path.join(vendor_dir, dst_name)

        status = 'old'
        if tag.name not in saved_tags:
            status = 'new'
            if not dry_run:
                urlretrieve(tag.tarball, path)
        logger.info('%s: %s tag %s -> %s', repo_name, status, tag.name, path)

        break


def deploy_repo(repo_name, vendor_dir, output_dir):
    with tarfile.open(arch_file.name, 'r:gz') as tar_file:
        tar_file.extractall(deploy_dir)


def create_parser():
    import argparse

    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument('-V', '--vendor', help='dir to store plugins',
                               default=os.path.join(VIM_ROOT, 'plugins'))
    parent_parser.add_argument('-v', '--verbose', action='count', default=0)
    parent_parser.add_argument('-n', '--dry-run', action='store_true')
    parent_parser.add_argument('-c', '--config', help='path to plugins config',
                               default=os.path.join(VIM_ROOT, 'plugins.conf'))

    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest='command')

    update = subparsers.add_parser('update', parents=[parent_parser])
    update.add_argument('repo', nargs='*', help='repo name')

    deploy = subparsers.add_parser('deploy', parents=[parent_parser])
    deploy.add_argument('-o', '--output', help='dir to deploy plugins',
                        default=os.path.join(VIM_HOME, 'dotfiles'))
    deploy.add_argument('repo', nargs='*', help='repo name')
    return parser


if __name__ == '__main__':
    args = create_parser().parse_args()
    init_logging(args.verbose)

    with open(args.config) as config_file:
        repos = json.load(config_file)

    if args.command == 'update':
        ignore_errors(os.makedirs, OSError)(args.vendor)
        repo_names = args.repo if args.repo else repos.keys()
        for repo_name in repo_names:
            try:
                repo_url = repos[repo_name]['url']
                logger.info('start update repo %s [url: %s]', repo_name, repo_url)
                update_repo(repo_name, repo_url, args.vendor,
                            dry_run=args.dry_run)
            except KeyError as e:
                logger.error('bad repo name %s', repo_name)

    elif args.command == 'deploy':
        repo_names = args.repo if args.repo else repos.keys()
        for repo_name in repo_names:
            deploy_repo(repo_name, args.vendor, args.deploy)
