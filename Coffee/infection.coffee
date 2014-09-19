class User
  constructor: (@id) ->
    @infected = no
    @coaches = []
    @students = []
    @traversal = 0     #Used for keeping track of traversions
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
  equals: (otherUser) ->
    if @id is otherUser.id
      return true
    return false
  infect: =>
    @infected = yes
  totalInfection: (traversalID) ->
    if @traversal isnt traversalID #Let's traverse over this user
      @traversal = traversalID
      @infect()

      for i,student of @students
        student.totalInfection traversalID

      for i,coach of @coaches
        coach.totalInfection traversalID


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
  traversalID = Math.floor(Math.random() * 1000)
  user.totalInfection traversalID

limited_infection = (user) ->
  traversalID = Math.floor(Math.random() * 1000)
  user.limited traversalID
