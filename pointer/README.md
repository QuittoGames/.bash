# pointer — Pontes de inicialização do Bash

Este diretório contém backup e documentação dos arquivos-ponte
que o sistema Linux/bash procura no `$HOME` e que redirecionam
para a configuração real dentro de `~/.bash/`.

## Arquivos

| Arquivo-ponte (em $HOME) | Redireciona para            | Quando é chamado                          |
|---------------------------|-----------------------------|-------------------------------------------|
| `~/.bashrc`               | `~/.bashrc.sh` → `~/.bash/.bashrc`           | Shells interativos não-login (terminais)  |
| `~/.bash_profile`         | `~/.bash_profile.sh` → `~/.bash/.bashrc`     | Shells de login (SSH, tty, su -)          |
| `~/.bash_logout`          | `~/.bash_logout.sh` → `~/.bash/.bash_logout` | Ao sair de um shell de login              |

## Por que existe

O Bash segue uma ordem fixa de inicialização:

1. **Login shell**: `/etc/profile` → `~/.bash_profile` (ou `~/.bash_login`, `~/.profile`)
2. **Non-login shell**: `/etc/bashrc` → `~/.bashrc`

Esses caminhos são硬-coded no Bash. Para centralizar toda config
em `~/.bash/`, criamos arquivos-ponte mínimos no `$HOME` que
simplesmente fazem `source` do arquivo real dentro de `~/.bash/`.

Isso permite:
- Organização: toda config do shell fica dentro de uma pasta
- Portabilidade: para replicar a config, basta copiar `~/.bash/`
- Clareza: os bridges são explícitos sobre o que está acontecendo

## Fluxo atual

```
bash (login):
  /etc/profile
    └── ~/.bash_profile (ponte)
          └── source ~/.bash_profile.sh
                └── source ~/.bash/.bashrc

bash (interactive non-login):
  /etc/bashrc
    └── ~/.bashrc (ponte)
          └── source ~/.bashrc.sh
                └── source ~/.bash/.bashrc

logout:
  ~/.bash_logout (ponte)
    └── source ~/.bash_logout.sh
          └── source ~/.bash/.bash_logout
```

## Backup

Os arquivos `.bak` neste diretório são cópias exatas dos bridges
no momento em que foram criados. Servem apenas como referência.
