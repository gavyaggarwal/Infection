class User
  constructor: (@id) ->
    @infected = no
    @coaches = []
    @students = []
    @traversal = 0     #Used for traversing users in hierarchy
  addCoach: (coach) ->
    if (@coaches.indexOf coach) is -1
      @coaches.push coach
      coach.addStudent @
  addCoaches: (coaches) ->
    for i,coach of coaches
      @addCoach coach
  addStudent: (student) ->
    if (@students.indexOf student) is -1
      @students.push student
      student.addCoach @
  addStudents: (students) ->
    for i,student of students
      @addStudent student
  infect: =>
    @infected = yes
  usersInChain: (infected, traversalID) ->
    users = 0
    if @traversal isnt traversalID
      @traversal = traversalID
      if infected
        users++ if @infected
      else
        users++

      for i,student of @students
        users += student.usersInChain infected, traversalID
      for i,coach of @coaches
        users += coach.usersInChain infected, traversalID
    return users
  infectedStudents: ->
    #Recursive function to calculate infected students
  totalInfection: (traversalID) ->
    if @traversal isnt traversalID #Let's traverse over this user
      @traversal = traversalID
      @infect()
      for i,student of @students
        student.totalInfection traversalID
      for i,coach of @coaches
        coach.totalInfection traversalID
  limitedInfection: (userBase, traversalID) ->

  startTotalInfection: ->
    traversalID = Math.floor(Math.random() * 1000)
    @totalInfection traversalID
  startLimitedInfection: ->
    traversalID = Math.floor(Math.random() * 1000)
    user.limitedInfection traversalID
  linkedUsers: ->
    traversalID = Math.floor(Math.random() * 1000)
    @usersInChain no, traversalID
  linkedInfectedUsers: ->
    traversalID = Math.floor(Math.random() * 1000)
    @usersInChain yes, traversalID

class UserBase
  constructor: ->
    @users = []
  populateUsers: (ids) ->
    for i in ids by 1
      user = new User i
      @addUser user
  addUser: (user) ->
    @users.push user
  totalUsers: ->
    @users.length
  getUser: (id) ->
    selectedUser = null
    for i,user of @users
      if user.id is id
        selectedUser = user
        break
    return selectedUser


total_infection = (user) ->
  do user.startTotalInfection

limited_infection = (user, infections) ->
  do user.startLimitedInfection
