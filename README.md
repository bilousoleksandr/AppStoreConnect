
1. Install mise 

```
curl https://mise.run | sh
~/.local/bin/mise --version
mise 2024.x.x
```

```
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
```

2. Install dependencies 

```
mise install
```

3. Generate project

```
tuist generate
```