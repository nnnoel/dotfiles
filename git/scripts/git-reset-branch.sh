BRANCH=$(git rev-parse --abbrev-ref HEAD)
git reset --hard origin/$BRANCH

