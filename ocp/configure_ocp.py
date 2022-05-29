import argparse
from pathlib import Path

import toml

parser = argparse.ArgumentParser()
parser.add_argument('--config-file', type=Path, default='./ocp.toml')
parser.add_argument('--input-folder', type=Path, required=True)
parser.add_argument('--args-whitespace-separated', type=str, default='')
parser.add_argument('--args', nargs='+', default=[])

args = parser.parse_args()
config = toml.load(args.config_file)

config['input_folder'] = str(args.input_folder)

original_args = config['args']
config['args'] = original_args + args.args_whitespace_separated.split() + args.args

with open(args.config_file, 'w') as f:
    toml.dump(config, f)
