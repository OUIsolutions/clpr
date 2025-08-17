# Building CLPR From Source

## Overview

Building CLPR from source allows you to customize the build process and access the latest development features. This process uses the Darwin build system to compile and package the CLPR library.

## Prerequisites

- Git for cloning the repository
- Internet connection for downloading dependencies
- Linux environment (recommended)

## Build Process

### Step 1: Clone the Repository

First, clone the CLPR source code repository and navigate to the project directory:

```bash
git clone https://github.com/OUIsolutions/Return-Main-Precat-rio-Operation
cd Return-Main-Precat-rio-Operation
```

This downloads the complete source code including:
- Source files in the `src/` directory
- Build configuration in `darwinconf.lua`
- Documentation and examples

### Step 2: Install Darwin Build System

Darwin is required to build CLPR from source. It handles dependency management and compilation.

#### Linux Installation

```bash
curl -L https://github.com/OUIsolutions/Darwin/releases/download/0.8.0/darwin.out -o darwin.out && sudo chmod +x darwin.out && sudo mv darwin.out /usr/bin/darwin
```

#### Verify Installation

Check that Darwin is properly installed:

```bash
darwin --version
```

### Step 3: Build the Project

Execute the build process using the Darwin configuration file:

```bash
darwin run_blueprint darwinconf.lua
```

This command will:
- Read the build configuration from `darwinconf.lua`
- Download required dependencies automatically
- Compile the source code
- Generate release files

### Step 4: Verify Build Output

After successful compilation, the following files will be generated in the `release/` directory:

```
release/
├── embed.lua
└── lib.lua
```

#### Generated Files

- **`lib.lua`**: The main CLPR library file for standard usage
- **`embed.lua`**: A standalone version that can be embedded directly into other projects

## Using the Built Library

### Standard Usage

Use `lib.lua` as you would use the pre-built version:

```lua
local clpr = require("release/lib")
-- Continue with normal CLPR usage
```

### Embedded Usage

The `embed.lua` file contains the complete library and can be included directly in your project without external dependencies.

## Troubleshooting

### Build Failures

- Ensure Darwin is properly installed and accessible in your PATH
- Check internet connectivity for dependency downloads
- Verify you have sufficient disk space for build artifacts

### Permission Issues

- Make sure you have write permissions in the project directory
- Run Darwin with appropriate permissions if needed

### Missing Dependencies

If the build fails due to missing dependencies, Darwin will typically provide clear error messages indicating what's missing. The dependencies are usually downloaded automatically during the build process.