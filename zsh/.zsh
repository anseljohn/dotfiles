alias deploy='./gradlew clean assemble deploy'
alias assemble='./gradlew assemble'
alias build='./gradlew build'
alias deps='./gradlew clean assemble --refresh-dependencies'

alias to='git checkout '
__git_complete to _git_checkout

alias 2020='cd /c/dev/robo/FRC-Robot-2020'
alias 2019='cd /c/dev/robo/FRC-Robot-2019'
alias 2019exp='cd /c/dev/robo/FRC-Robot-2019-Experiemental'
alias robo='cd /c/dev/robo'
alias bunnybot='cd /c/dev/robo/FRC-BunnyBots-2019'
alias 2018='cd /c/dev/robo/FRC-Robot-2018'
alias branches='git branch -al'
newalias() {
	echo alias $1=\'$2\' >> ~/.bashrc
	source ~/.bashrc
}
alias in='git pull'
alias out='git push'
alias pause='git stash'
alias resume='git stash pop'
alias drop='git stash drop'
alias update='git merge master'
alias commit='git add .; git commit -m'
rewind() {
	git reset HEAD~
	git reset --hard
}
alias reload='source ~/.bashrc'
alias fullhist='git log --graph --pretty --all'
alias hist='git log --graph --pretty=oneline --all'
commitsfrom() {
	git log --graph --pretty --all --author $1
}
alias bashrc='notepad ~/.bashrc'
alias shuffle='./gradlew shuffleboard'
alias stage='git add .'
