class User
  constructor: (@id) ->
    @infected = no
    @coaches = []
    @students = []
    @traversal = 0     #Used for traversing users in hierarchy
    @userbase = null   #Used to "connect" to users that aren't in coach/student hierarchy
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
    #If this user has students, it must be a coach
    if @userbase then @userbase.addCoach @
  addStudents: (students) ->
    for i,student of students
      @addStudent student
  infect: =>
    prevState = @infected
    @infected = yes
    #console.log "Infecting User #{@id}"
    if prevState then no else yes
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
  countInfectedStudents: (traversalID) ->
    users = 0
    if @traversal isnt traversalID
      @traversal = traversalID
      users++ if @infected

      for i,student of @students
        users += student.countInfectedStudents traversalID
    return users
  totalInfection: (traversalID) ->
    if @traversal isnt traversalID #Let's traverse over this user
      @traversal = traversalID
      @infect()
      for i,student of @students
        student.totalInfection traversalID
      for i,coach of @coaches
        coach.totalInfection traversalID
  #This version caps the number of infected users
  limitedInfection2: (traversalID, remaining) ->
    if @traversal isnt traversalID and remaining > 0
      @traversal = traversalID
      if @infect() then remaining--
      for student in @students
        remaining = student.limitedInfection2 traversalID, remaining
    remaining

  startTotalInfection: ->
    traversalID = Math.floor(Math.random() * 1000)
    @totalInfection traversalID
  startLimitedInfection: (infections) ->
    traversalID = Math.floor(Math.random() * 1000)
    @limitedInfection traversalID, infections
  infectedStudents: ->
    traversalID = Math.floor(Math.random() * 1000)
    infectedCount = @countInfectedStudents traversalID
    infectedCount-- if @infected #We don't count the current user
    return infectedCount
  percentInfectedStudents: ->
    if @students.length is 0
      return 0
    @infectedStudents() / @students.length * 100
  linkedUsers: ->
    traversalID = Math.floor(Math.random() * 1000)
    @usersInChain no, traversalID
  linkedInfectedUsers: ->
    traversalID = Math.floor(Math.random() * 1000)
    @usersInChain yes, traversalID

class UserBase
  constructor: ->
    @users = []
    @coaches = []
  populateUsers: (ids) ->
    for i in ids by 1
      user = new User i
      @addUser user
  addUser: (user) ->
    user.userbase = @
    @users.push user
  totalUsers: ->
    @users.length
  getUser: (id) ->
    selectedUser = null
    for i,user of @users
      if user.id is id
        selectedUser = user
        break
    selectedUser
  getUsers: (ids) ->
    users = []
    for i,id of ids
      user = @getUser id
      users.push user if user isnt null
    users
  infectedUsersCount: ->
    count = 0
    for user in @users
      if user.infected then count++
    count
  addCoach: (coach) ->
    if (@coaches.indexOf coach) is -1
      @coaches.push coach

total_infection = (user) ->
  do user.startTotalInfection

limited_infection = (user, infections) ->
  user.startLimitedInfection infections
