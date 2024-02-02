pre-commit-golang
=================

golang hooks for http://pre-commit.com/

### Using these hooks

In your project root dir add this to `.pre-commit-config.yaml`

    -   repo: https://github.com/troian/pre-commit-golang
        sha: HEAD
        hooks:
        -   id: go-fmt
        -   id: go-build
        -   id: go-metalinter
            args:
            - --exclude=corefoundation.go
            - --deadline=60s
            - --vendor
            - --cyclo-over=20
            - --dupl-threshold=100
            - --disable=gotype

### Available hooks

- `go-fmt` - Runs `gofmt`, requires golang