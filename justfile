# shellcheck disable=SC2148
default:
    #!/bin/bash
    just --choose

all: download build install 

download:
    #!/bin/bash
    ./scripts/10_download.sh

build $OS_RELEASE_ID='fedora' $VERSION_ID='39':
    #!/bin/bash
    ./scripts/20_build.sh

install:
    #!/bin/bash
    ./scripts/30_install.sh

docs:
    #!/bin/bash
    ./scripts/50_docs.sh

hooks:
    #!/bin/bash
    ln -s -f ../../hooks/pre-commit .git/hooks/pre-commit

clean:
    #!/bin/bash
    ./scripts/90_clean.sh

