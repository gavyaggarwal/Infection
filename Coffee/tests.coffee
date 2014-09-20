QUnit.test "Can Create User", (assert) ->
  user = new User 0
  assert.ok user, "User Created"
  assert.equal user.linkedUsers(), 1, "Reports 1 User in Chain"

QUnit.test "Can Assign Coach (u1) to User (u0)", (assert) ->
  u0 = new User 0
  u1 = new User 1
  u0.addCoach u1
  assert.equal u1.students[0], u0, "u1's students contains u0"
  assert.equal u0.coaches[0], u1, "u0's coaches contains u1"
  assert.equal u1.linkedUsers(), 2, "u1 Reports 2 Users in Chain"
  assert.equal u0.linkedUsers(), 2, "u0 Reports 2 Users in Chain"

QUnit.test "Can Assign Students (u1 and u2) to User (u0)", (assert) ->
  u0 = new User 0
  u1 = new User 1
  u2 = new User 2
  u0.addStudents [u1,u2]
  assert.deepEqual u0.students, [u1, u2], "u0's students are u1 and u2"
  assert.deepEqual u1.coaches, [u0], "u1's coach is u0"
  assert.deepEqual u2.coaches, [u0], "u2's coach is u0"
  assert.equal u0.linkedUsers(), 3, "u0 Reports 3 Users in Chain"
  assert.equal u1.linkedUsers(), 3, "u1 Reports 3 Users in Chain"
  assert.equal u2.linkedUsers(), 3, "u2 Reports 3 Users in Chain"
  assert.equal u0.infectedStudents(), 0, "u0 reports 0 infected students"

QUnit.test "User Base Can Be Created (With 10 Users)", (assert) ->
  users = new UserBase
  users.populateUsers [0...10]
  assert.ok users, "User Base Exists"
  assert.equal users.totalUsers(), 10, "User Base Has 10 Users"

QUnit.test "Total Infection on a lone user (u1) but not on another lone user (u2)", (assert) ->
  users1 = new UserBase
  users1.populateUsers [1...3]
  u1 = users1.getUser 1
  u2 = users1.getUser 2
  total_infection u1
  assert.equal u1.infected, yes, "u1 is infected"
  assert.equal u2.infected, no, "u2 is not infected"

QUnit.test "Total Infection on Coach (u1) with a Student (u2) but not on a lone user (u3)", (assert) ->
  users2 = new UserBase
  users2.populateUsers [1...4]
  u1 = users2.getUser 1
  u2 = users2.getUser 2
  u3 = users2.getUser 3
  u1.addStudent u2
  total_infection u1
  assert.equal u1.infected, yes, "u1 is infected"
  assert.equal u2.infected, yes, "u2 is infected"
  assert.equal u3.infected, no, "u3 is not infected"

QUnit.test "Coach (c1) with Students (s1, s2, s3), Coach (c2) with Students (s4, s5), Total Infection on s3", (assert) ->
  users = new UserBase
  users.populateUsers [1...8]
  c1 = users.getUser 1
  c2 = users.getUser 2
  s1 = users.getUser 3
  s2 = users.getUser 4
  s3 = users.getUser 5
  s4 = users.getUser 6
  s5 = users.getUser 7
  c1.addStudents [s1,s2,s3]
  c2.addStudents [s4,s5]
  total_infection s3
  assert.equal c1.infected, yes, "c1 is infected"
  assert.equal s1.infected, yes, "s1 is infected"
  assert.equal s2.infected, yes, "s2 is infected"
  assert.equal s3.infected, yes, "s3 is infected"
  assert.equal c2.infected, no, "c2 is not infected"
  assert.equal s4.infected, no, "s4 is not infected"
  assert.equal s5.infected, no, "s5 is not infected"

QUnit.test "Coach (c1) with Students (s1, s2, c2), Coach (c2) with Students (s3, s4, s5), Total Infection on s3", (assert) ->
  users = new UserBase
  users.populateUsers [1...8]
  c1 = users.getUser 1
  c2 = users.getUser 2
  s1 = users.getUser 3
  s2 = users.getUser 4
  s3 = users.getUser 5
  s4 = users.getUser 6
  s5 = users.getUser 7
  c1.addStudents [s1,s2,c2]
  c2.addStudents [s3,s4,s5]
  total_infection s3
  assert.equal c1.infected, yes, "c1 is infected"
  assert.equal c2.infected, yes, "c2 is infected"
  assert.equal s1.infected, yes, "s1 is infected"
  assert.equal s2.infected, yes, "s2 is infected"
  assert.equal s3.infected, yes, "s3 is infected"
  assert.equal s4.infected, yes, "s4 is infected"
  assert.equal s5.infected, yes, "s5 is infected"
  assert.equal c1.infectedStudents(), 6, "c1 reports 6 infected students"
  assert.equal c2.infectedStudents(), 3, "c2 reports 3 infected students"

QUnit.test "Total Infection with Large, Complex Dataset (1000 Users)", (assert) ->
  users = new UserBase
  users.populateUsers [1..1000]
  c1 = users.getUser 1
  c2 = users.getUser 2
  c3 = users.getUser 3
  c4 = users.getUser 4
  c5 = users.getUser 5
  c1.addStudents users.getUsers [6..100]
  c1.addStudents [c2, c3]
  c2.addStudents users.getUsers [101..300]
  c3.addStudents users.getUsers [101..200]
  c3.addStudents [c4, c5]
  c4.addStudents users.getUsers [301..400]
  c5.addStudents users.getUsers [401..500]

  assert.equal users.infectedUsersCount(), 0, "User base reports correct
  infected count before infection"

  total_infection users.getUser 694

  assert.equal users.infectedUsersCount(), 1, "User base reports correct
  infected count after first infection"

  total_infection users.getUser 230

  assert.equal users.infectedUsersCount(), 501, "User base reports correct
  infected count after both infections"

  assert.equal c1.infectedStudents(), 499, "Test Coach 1 reports correct
   number infected students"
  assert.equal c3.infectedStudents(), 302, "Test Coach 2 reports correct
   number infected students"

QUnit.test "Limited Infection (C, 6) on Coach (C) with 3 Students", (assert) ->
  users = new UserBase
  users.populateUsers [1..4]
  c = users.getUser 1
  c.addStudents users.getUsers [2..4]
  numInfected = limited_infection c, 6
  assert.equal c.infected, yes, "Coach C is infected"
  assert.equal c.percentInfectedStudents(), 100, "100% of coach's
   students are infected"
  assert.equal numInfected, 4, "4 users infected"

QUnit.test "Limited Infection (A, 6) for 3 Coaches with 3 Students Each", (assert) ->
  users = new UserBase
  users.populateUsers [1..12]
  c1 = users.getUser 1
  c2 = users.getUser 2
  c3 = users.getUser 3
  c1.addStudents users.getUsers [4..6]
  c2.addStudents users.getUsers [7..9]
  c3.addStudents users.getUsers [10..12]
  limited_infection c1, 6
  assert.equal c1.infected, yes, "Coach A is infected"
  assert.equal c1.percentInfectedStudents(), 100, "All of Coach A's
  students are infected"
  assert.equal c2.infected, yes, "Coach B is infected"
  assert.equal c2.percentInfectedStudents(), 100, "All of Coach B's
  students are infected"
  assert.equal c3.infected, no, "Coach C is not infected"
  assert.equal c3.percentInfectedStudents(), 0, "None of Coach C's
  students are infected"

QUnit.test "Limited Infection (C, 1) where A coaches B and B coaches C", (assert) ->
  users = new UserBase
  users.populateUsers [1..3]
  c1 = users.getUser 1
  c2 = users.getUser 2
  s3 = users.getUser 3
  c1.addStudent c2
  c2.addStudent s3
  limited_infection s3, 1
  assert.equal c1.infected, no, "A is not infected"
  assert.equal c1.percentInfectedStudents(), 50, "Half of A's
  students are infected"
  assert.equal c2.infected, no, "B is not infected"
  assert.equal c2.percentInfectedStudents(), 100, "All of B's
  students are infected"
  assert.equal s3.infected, yes, "C is infected"

QUnit.test "Limited Infection (C, 2) where A coaches B and B coaches C", (assert) ->
  users = new UserBase
  users.populateUsers [1..3]
  c1 = users.getUser 1
  c2 = users.getUser 2
  s3 = users.getUser 3
  c1.addStudent c2
  c2.addStudent s3
  limited_infection s3, 2
  assert.equal c1.infected, no, "A is not infected"
  assert.equal c1.percentInfectedStudents(), 100, "All of Coach A's
  students are infected"
  assert.equal c2.infected, yes, "B is infected"
  assert.equal c2.percentInfectedStudents(), 100, "All of Coach B's
  students are infected"
  assert.equal s3.infected, yes, "C is infected"

QUnit.test "Limited Infection (C, 3) where A coaches B and B coaches C", (assert) ->
  users = new UserBase
  users.populateUsers [1..3]
  c1 = users.getUser 1
  c2 = users.getUser 2
  s3 = users.getUser 3
  c1.addStudent c2
  c2.addStudent s3
  limited_infection s3, 3
  assert.equal c1.infected, yes, "A is infected"
  assert.equal c2.infected, yes, "B is infected"
  assert.equal s3.infected, yes, "C is infected"


QUnit.test "Limited Infection with Large, Complex Dataset (1000 Users)", (assert) ->
  users = new UserBase
  users.populateUsers [1..1000]
  u3 = users.getUser 3
  u5 = users.getUser 5
  u11 = users.getUser 11
  u12 = users.getUser 12
  u13 = users.getUser 13
  u14 = users.getUser 14
  u15 = users.getUser 15
  u16 = users.getUser 16

  u3.addStudents users.getUsers [17..100]
  u3.addStudents [u11, u12]
  u5.addStudents users.getUsers [301..400]
  u11.addStudents users.getUsers [101..200]
  u12.addStudents users.getUsers [201..300]
  u16.addCoaches users.getUsers [1..10]
  u13.addStudent u14
  u13.addStudents users.getUsers [851..900]
  u14.addStudents users.getUsers [901..950]
  u15.addStudents users.getUsers [951..1000]

  assert.equal users.infectedUsersCount(), 0, "User base reports correct
  infected count before infection"

  infected = limited_infection (users.getUser 9), 110

  assert.equal infected, 110, "Correct number of users infected"
