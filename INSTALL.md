# Instalação e configuração

As dependências de sistema desse projeto são

- [VirtualBox](https://www.virtualbox.org/); e
- [Vagrant](https://www.vagrantup.com/), [vagrant-env](https://github.com/gosuri/vagrant-env), e em alguns casos [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf)

Se você estiver na CAMG seu acesso à internet será via proxy. Nesse caso instale o plugin `vagrant-proxyconf`

```bash
vagrant plugin install vagrant-proxyconf
```

e crie as variáveis de ambiente `VAGRANT_HTTP_PROXY` `VAGRANT_HTTPS_PROXY` com o valor `http://<user>:<password>@<host>:<port>` substituindo as variáveis entre `<>`. Certifique-se também que as variáveis `http_proxy` e `https_proxy` estão criadas com o mesmo valor (em caixa baixa). Enquanto as primeiras permitem conectividade para a VM, as últimas permitem conectividade para o próprio Vagrant.

Depois disso clone o repositório e execute a inicialização

```bash
git clone https://github.com/dados-mg/etl-make.git
cd etl-make
vagrant up
```

A primeira execução demora alguns minutos. Você pode logar nas máquinas virtuais `etl` e `db` com

```bash
vagrant ssh etl
vagrant ssh db
```