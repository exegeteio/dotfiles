# Based on kickstart-modular.nvim

Copy over a new copy:

```bash
cd /tmp/
gh repo clone dam9000/kickstart-modular.nvim
cp kickstart-modular.nvim/init.lua ~/code/dotfiles/xdg_config/nvim/
cp -r kickstart-modular.nvim/lua ~/code/dotfiles/xdg_config/nvim/
rm -Rf kickstart-modular.nvim
cd -
```
