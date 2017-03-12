#!/usr/bin/env python
# coding: utf-8

import collections
import json
import logging
import os
import tarfile
import tempfile

try:
    from urllib import  urlretrieve
    from urllib2 import urlopen
except ImportError:
    from urllib.request import urlretrieve, urlopen

logger = logging.getLogger('update_plugins')

REPOS = {
    'python-mode': 'https://github.com/python-mode/python-mode',
}

VIM_ROOT = os.path.dirname(os.path.abspath(__file__))
VIM_HOME = os.path.join(os.path.expanduser('~'), '.vim')


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


def update_repo(repo_name, vendor_dir, check_tag=lambda _: True,
                dry_run=False):
    repo_url = REPOS[repo_name]
    logger.info('start update repo %s [url: %s]', repo_name, repo_url)

    saved_tags = {name.split('_')[-1] for name in os.listdir(vendor_dir)
                  if name.startswith(repo_name)}

    for tag in (t for t in extract_tags(repo_url) if check_tag(t.name)):
        dst_name = '{}_{}.tar.gz'.format(repo_name, tag.name)
        dst_path = os.path.join(vendor_dir, dst_name)

        if tag.name not in saved_tags:
            logger.info('%s: new tag %s -> %s', repo_name, tag.name, dst_path)
            urlretrieve(tag.tarball, dst_path)
        else:
            logger.info('%s: old tag %s -> %s', repo_name, tag.name, dst_path)

        break


def deploy_repo(repo_name, vendor_dir, deploy_dir):
    with tarfile.open(arch_file.name, 'r:gz') as tar_file:
        tar_file.extractall(deploy_dir)


def create_parser():
    import argparse

    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument('-V', '--vendor-dir',
                               help='dir to store side plugins',
                               default=os.path.join(VIM_ROOT, 'plugins'))
    parent_parser.add_argument('-v', '--verbose', action='count', default=0)
    parent_parser.add_argument('-n', '--dry-run', action='store_true')
    parent_parser.add_argument('repo', nargs='*', help='repo name')

    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest='command')

    update = subparsers.add_parser('update', parents=[parent_parser])

    deploy = subparsers.add_parser('deploy', parents=[parent_parser])
    deploy.add_argument('-d', '--deploy-dir',
                        default=os.path.join(VIM_HOME, 'dotfiles'),
                        help='dir to deploy side plugins')
    return parser


if __name__ == '__main__':
    args = create_parser().parse_args()
    init_logging(args.verbose)

    if args.command == 'update':
        repo_names = args.repo if args.repo else REPOS
        for repo_name in repo_names:
            try:
                update_repo(repo_name, args.vendor_dir)
            except KeyError as e:
                logger.error('bad repo name %s', repo_name)

    elif args.command == 'deploy':
        repo_names = args.repo if args.repo else REPOS
        for repo_name in repo_names:
            deploy_repo(repo_name, args.vendor_dir, args.deploy_dir)
