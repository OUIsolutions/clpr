for build from scratch,follow these steps:

### Step1: Clone the repository
```bash
git clone https://github.com/OUIsolutions/Return-Main-Precat-rio-Operation
cd Return-Main-Precat-rio-Operation
```
### Step 2: Install [darwin](https://github.com/OUIsolutions/Darwin)
if you are on linux, you can install darwin with:
```bash
curl -L https://github.com/OUIsolutions/Darwin/releases/download/0.8.0/darwin.out -o darwin.out && sudo chmod +x darwin.out && sudo mv darwin.out /usr/bin/darwin
```

### Step 3: Build the project
```bash
darwin run_blueprint darwinconf.lua 
```
it will interpret the [darwinconf.lua](/darwinconf.lua) file and build the project, downloading the dependencies and generating the following releases:
```
release/
├── embed.lua
└── lib.lua
```
where `lib.lua` is the main library file and `embed.lua` is a file that can be used to embed the library in other projects.