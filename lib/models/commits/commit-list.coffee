_ = require 'lodash'
git    = require '../../git'
List   = require '../list'
Commit = require './commit'
ErrorView = require '../../views/error-view'

class CommitList extends List
  model: Commit

  # Public: Reload the commit list.
  #
  # branch - The branch to reload the commits for as {Branch}.
  reload: (branch) =>
    @branch = branch
    git.log(@branch.head())
    .then (commits) =>
      @repopulate _.map(commits, (commit) -> new Commit(commit))
    .catch (error) ->
      new ErrorView(error)

  # Public: Repopulate the commit list with the commitHashes.
  #
  # commitHashes - The commit hashes to repopulate with as {Arraya}.
  repopulate: (commitHashes) ->
    @reset(commitHashes)
    @trigger 'repopulate'
    @select @selectedIndex

module.exports = CommitList
