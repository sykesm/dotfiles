# My Dotfiles

It's time to give my dot files a home. This is it.

## Setup

I'm using the [pattern] outlined in hacker news a few years ago where `$HOME`
is the git work tree and the repository is placed in a hidden directory.

Assuming an SSH key with access to the repository is available to the
ssh-agent, the following will clone the dotfiles, populate `$HOME`, install
[bash-it], and [tpm] for [tmux].

```sh
    git clone --bare https://github.com/sykesm/dotfiles "$HOME/.dotfiles"
    alias dotfiles='git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
    dotfiles config --local status.showUntrackedFiles no
    dotfiles config --local core.excludesFile "$HOME/.dot-gitignore"
    dotfiles checkout -f # destroys any local changes

    if [ ! -d ~/.bash_it ]; then
        git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
        ~/.bash_it/install.sh --silent --no-modify-config
        echo 'bash-it enable completion ssh terraform tmux xterm' | bash -i
    fi

    if [ ! -d ~/.oh-my-zsh ]; then
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    fi

    if [ ! -d ~/.zsh-syntax-highlighting ]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
    fi

    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        ~/.tmux/plugins/tpm/bin/install_plugins
    fi

    if [ "$(uname)" == "Darwin" ] && [ ! -x ~/.cargo/bin/rustup ]; then
        rustup-init --no-modify-path -y
        source $HOME/.cargo/env
        rustup toolchain add nightly
        rustup component add rust-src
        cargo +nightly install racer
    fi
```

If the repo is private and the SSH key is available as a file and not loaded
into the agent, the `GIT_SSH_COMMAND` environment variable can be used to
point to the key to use for the clone.

```sh
    GIT_SSH_COMMAND="ssh -i $HOME/.ssh/id_rsa_deploy" git clone --bare git@github.com:sykesm/dotfiles "$HOME/.dotfiles"
```

## cloud-init

The following is an outline of a cloud-init based setup for a development box.
The keys have been removed and need to be replaced with the appropriate
material.

```yaml
    #cloud-config
    # vim: syntax=yaml
    
    growpart:
      mode: auto
      devices: ['/']
      ignore_growroot_disabled: false
    
    apt:
      preserve_sources_list: true
      sources:
        vim:
          source: "ppa:jonathonf/vim"
    
    packages:
    - apt-transport-https
    - build-essential
    - bzr
    - ca-certificates
    - clang
    - curl
    - direnv
    - dnsutils
    - docker.io
    - git
    - git-crypt
    - grc
    - htop
    - jq
    - libltdl-dev
    - libprotobuf-dev
    - libtool
    - less
    - locales
    - man
    - mosh
    - ncat
    - nmap
    - openssh-server
    - pkg-config
    - protobuf-compiler
    - rsync
    - shellcheck
    - silversearcher-ag
    - socat
    - softhsm2
    - software-properties-common
    - sudo
    - tig
    - tmux
    - tree
    - universal-ctags
    - unzip
    - vim
    - wget
    - zip
    - zsh
    package_update: true
    package_upgrade: true
    package_reboot_if_required: true
    
    ssh_deletekeys: true
    ssh_keys:
      dsa_private: |
        -----BEGIN DSA PRIVATE KEY-----
        ...
        -----END DSA PRIVATE KEY-----
      dsa_public: ssh-dss ...
      ecdsa_private: |
        -----BEGIN EC PRIVATE KEY-----
        ...
        -----END EC PRIVATE KEY-----
      ecdsa_public: ecdsa-sha2-nistp256 ...
      ed25519_private: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        ...
        -----END OPENSSH PRIVATE KEY-----
      ed25519_public: ssh-ed25519 ...
      rsa_private: |
        -----BEGIN RSA PRIVATE KEY-----
        ...
        -----END RSA PRIVATE KEY-----
      rsa_public: ssh-rsa ...
    
    timezone: America/New_York
    
    users:
    - name: root
      ssh_authorized_keys:
      - ssh-rsa ...
    - name: sykesm
      gecos: Matthew Sykes
      lock_passwd: false
      # If a password login is required, use mkpasswd --method=SHA-512 --rounds=4096 to create the hash
      # passwd: $6$rounds=4096$...$...
      shell: /bin/bash
      sudo: ALL=(ALL) NOPASSWD:ALL
      ssh_authorized_keys:
      - ssh-rsa ...
      uid: 1000
     
    write_files:
    - path: /etc/systemd/system/papertrail.service
      permissions: '0644'
      owner: root:root
      content: |
        [Unit]
        Description=Papertrail
        After=systemd-journald.service
        Requires=systemd-journald.service
    
        [Service]
        ExecStart=/bin/sh -c "journalctl -f | ncat --ssl logs3.papertrailapp.com 41912"
        TimeoutStartSec=0
        Restart=on-failure
        RestartSec=5s
    
        [Install]
        WantedBy=multi-user.target
    - path: /etc/profile.d/golang.sh
      permissions: '0644'
      content: |
        export PATH=$PATH:/usr/local/go/bin 
    
    runcmd:
    - usermod -a -G docker,sudo sykesm
    - locale-gen en_US.UTF-8
    - update-locale LANG=en_US.UTF-8
    - systemctl enable /etc/systemd/system/papertrail.service
    - systemctl start papertrail.service
    - wget -qO- https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz | tar -C /usr/local -xzf -
    - |
        sudo -H -u sykesm bash <<'EOF'
        #!/bin/bash
    
        set -eu -o pipefail
        set -x
    
        github_host_key="github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
        github_host_key_hashed="|1|xxuE72vU0fTiddeOeBoHSlvFriE=|zoU/xBvKeSAhBrp5s3IDoLKpUCk= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
        echo "$github_host_key" >> "$HOME/.ssh/known_hosts"
        echo "$github_host_key_hashed" >> "$HOME/.ssh/known_hosts"
    
        git clone --bare https://github.com/sykesm/dotfiles "$HOME/.dotfiles"
        git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config --local status.showUntrackedFiles no
        git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config --local core.excludesFile "$HOME/.dot-gitignore"
        git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" checkout -f
    
        if [ ! -d ~/.bash_it ]; then
            git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
            ~/.bash_it/install.sh --silent --no-modify-config
            echo 'bash-it enable completion ssh terraform tmux xterm' | bash -i
        fi

        if [ ! -d ~/.oh-my-zsh ]; then
            git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
        fi

        if [ ! -d ~/.zsh-syntax-highlighting ]; then
            git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
        fi
    
        if [ ! -d ~/.tmux/plugins/tpm ]; then
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
            ~/.tmux/plugins/tpm/bin/install_plugins
        fi
    
        mkdir -p "$HOME/.tokens"
        softhsm2-util --init-token --slot 0 --label "ForFabric" --so-pin 1234 --pin 98765432

        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
        source $HOME/.cargo/env
        rustup toolchain add nightly
        rustup component add rust-src
        cargo +nightly install racer
        EOF
```

The required vim plugins will be installed on first use.

[pattern]: https://news.ycombinator.com/item?id=11070797
[bash-it]: https://github.com/Bash-it/bash-it
[tpm]: https://github.com/tmux-plugins/tpm
[tmux]: https://github.com/tmux/tmux
