#!/bin/sh

#
#  Configure: vim
#

echo 'Configuring vim.'

VIM_POLYGLOT_RELEASE='v4.17.0'
VIM_POLYGLOT_REPO='https://github.com/sheerun/vim-polyglot'
TEST_CMD="vim -c ':set t_ti= t_te= nomore' -c 'scriptnames|q!' 2>/dev/null| grep -q vim-polyglot"

VIM_PLUG_DIR=/usr/share/vim/vimfiles/pack/plugins
mkdir -p $VIM_PLUG_DIR/start/vim-polyglot

printf "Installing vim plugin: vim-polyglot (%s)\n" "$VIM_POLYGLOT_RELEASE"

(
  cd $VIM_PLUG_DIR/start/vim-polyglot || exit 1
  curl -sSL "$VIM_POLYGLOT_REPO/archive/$VIM_POLYGLOT_RELEASE.tar.gz" | tar xz --strip=1
)

cat >> /etc/vimrc <<'EOD'
set belloff=all
if &t_Co > 2 || has ("gui_running")
  colorscheme industry
endif
EOD

cat >> /etc/profile.d/sh.local <<'EOD'
export EDITOR=vim
export VISUAL=vim
EOD

eval $TEST_CMD || {
printf "Failed to install vim-polyglot plugin (%s) for vim\n:" "$VIM_POLYGLOT_RELEASE" 
printf "Command '%s' failed with status %s.\n" "$TEST_CMD" "$?"
exit 1
}
