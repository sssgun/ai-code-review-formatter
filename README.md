# AI Code Review Formatter

A versatile command-line tool that prepares source code for AI-powered code review and analysis. This tool formats your codebase into markdown files optimized for AI tools like ChatGPT, Perplexity AI, and other LLM-based code analysis platforms.

## Features

- **Smart File Splitting**: Automatically splits large codebases into optimally sized chunks for AI analysis
- **Markdown Formatting**: Creates well-structured markdown files with proper code highlighting
- **Project Context**: Preserves project structure and relationships between files
- **File Statistics**: Includes metadata like file size, line count, and dependencies
- **Cross-Platform**: Works on Linux, macOS, and other Unix-like systems
- **AI Tool Optimization**: Formatted output is optimized for various AI analysis tools

## Installation

```bash
git clone https://github.com/sssgun/ai-code-review-formatter.git
cd ai-code-review-formatter
chmod +x prepare_code_analysis.sh
```

## Usage

```bash
./prepare_code_analysis.sh [source_directory] [output_directory]
```

### Arguments

- `source_directory`: Directory containing source files (default: current directory)
- `output_directory`: Directory for output files (default: current directory)

### Output Format

The script generates markdown files with the following structure:
```
{project_name}_{index}_{timestamp}.md
```

Each file contains:
- Project information and structure
- File metadata (size, line count)
- Syntax-highlighted source code
- File relationships and dependencies

## Why Use This Tool?

1. **AI-Friendly Format**: Output is specifically designed for AI code analysis tools
2. **Maintains Context**: Preserves project structure and file relationships
3. **Size Management**: Handles large codebases by intelligently splitting files
4. **Documentation Ready**: Generated files can also serve as project documentation

## Example

```bash
# Analyze a Python project
./prepare_code_analysis.sh ~/projects/my-python-project ./analysis

# Review the generated files
ls -l ./analysis/
```

## Technical Details

- Maximum file size: 25MB (configurable)
- Default token limit: 32,000 tokens
- Supported file types: Currently optimized for Python files
- Output format: Markdown with GitHub-flavored syntax highlighting

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the need for efficient code review using AI tools
- Designed to work with various AI platforms including ChatGPT and Perplexity AI
- Built to handle large codebases while maintaining context and readability
