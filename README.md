# project2prompt

Convert your project directory into a prompt-ready format for Large Language Models.

## Features

- Generate a tree view of the project structure
- Process all file types
- Ignore specific files or patterns
- Option to include default hidden files (`.gitignore` and `LICENCE`)
- Custom output file naming and location
- Comment scrubbing to reduce token count

## Dependencies

- Bash (version 4.0 or later)
- tree

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/MohamedElashri/project2prompt.git
   ```

2. Make the script executable:
   ```
   chmod +x project2prompt.sh
   ```

3. (Optional) Add to PATH:
   ```
   echo 'export PATH="$PATH:/path/to/project2prompt"' >> ~/.bashrc
   source ~/.bashrc
   ```

## Usage

```
project2prompt [OPTIONS] [DIRECTORY]
```

If no directory is specified, the current directory is used.

### Options

- `-i, --ignore PATTERN`: Ignore files matching PATTERN (can be used multiple times)
- `-a, --all`: Include hidden files
- `-o, --output FILE`: Specify output file name (without .md extension)
- `-d, --output-dir DIR`: Specify output directory
- `-s, --scrub-comments`: Remove comments from the output file
- `-h, --help`: Display help message

## Examples

1. Process current directory:
   ```
   project2prompt
   ```

2. Process a specific directory:
   ```
   project2prompt /path/to/your/project
   ```

3. Ignore specific files and include hidden files:
   ```
   project2prompt -i "*.log" -i "build" -a /path/to/your/project
   ```

4. Custom output name and location with comment scrubbing:
   ```
   project2prompt -o "my_project_prompt" -d "/path/to/output" -s /path/to/your/project
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

