QUnit.test "Can Create User", (assert) ->
  user = new User 0
  assert.ok user, "User Created"

QUnit.test "Can Assign Students (u1 and u2) to User (u0)", (assert) ->
  u0 = new User 0
  u1 = new User 1
  u2 = new User 2
  u0.addStudents [u1,u2]
  assert.deepEqual u0.students, [u1, u2], "u0's students are u1 and u2"
  assert.deepEqual u1.coaches, [u0], "u1's coach is u0"
  assert.deepEqual u2.coaches, [u0], "u2's coach is u0"

QUnit.test "Can Assign Coach (u1) to User (u0)", (assert) ->
  u0 = new User 0
  u1 = new User 1
  u0.addCoach u1
  assert.equal u1.students[0], u0, "u1's students contains u0"
  assert.equal u0.coaches[0], u1, "u0's coaches contains u1"

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

QUnit.test "Total Infection Works with 1 Coach with a Student", (assert) ->
  users2 = new UserBase
  users2.populateUsers [0...2]
  u0 = users2.getUser 0
  u1 = users2.getUser 1
  u0.addStudent u1
  total_infection u0
  success = (u0.infected is yes) && (u1.infected is yes)
  assert.ok success, "Success"
