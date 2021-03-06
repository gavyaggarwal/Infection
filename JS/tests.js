// Generated by CoffeeScript 1.7.1
QUnit.test("Can Create User", function(assert) {
  var user;
  user = new User(0);
  assert.ok(user, "User Created");
  return assert.equal(user.linkedUsers(), 1, "Reports 1 User in Chain");
});

QUnit.test("Can Assign Coach (u1) to User (u0)", function(assert) {
  var u0, u1;
  u0 = new User(0);
  u1 = new User(1);
  u0.addCoach(u1);
  assert.equal(u1.students[0], u0, "u1's students contains u0");
  assert.equal(u0.coaches[0], u1, "u0's coaches contains u1");
  assert.equal(u1.linkedUsers(), 2, "u1 Reports 2 Users in Chain");
  return assert.equal(u0.linkedUsers(), 2, "u0 Reports 2 Users in Chain");
});

QUnit.test("Can Assign Students (u1 and u2) to User (u0)", function(assert) {
  var u0, u1, u2;
  u0 = new User(0);
  u1 = new User(1);
  u2 = new User(2);
  u0.addStudents([u1, u2]);
  assert.deepEqual(u0.students, [u1, u2], "u0's students are u1 and u2");
  assert.deepEqual(u1.coaches, [u0], "u1's coach is u0");
  assert.deepEqual(u2.coaches, [u0], "u2's coach is u0");
  assert.equal(u0.linkedUsers(), 3, "u0 Reports 3 Users in Chain");
  assert.equal(u1.linkedUsers(), 3, "u1 Reports 3 Users in Chain");
  assert.equal(u2.linkedUsers(), 3, "u2 Reports 3 Users in Chain");
  return assert.equal(u0.infectedStudents(), 0, "u0 reports 0 infected students");
});

QUnit.test("User Base Can Be Created (With 10 Users)", function(assert) {
  var users;
  users = new UserBase;
  users.populateUsers([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
  assert.ok(users, "User Base Exists");
  return assert.equal(users.totalUsers(), 10, "User Base Has 10 Users");
});

QUnit.test("Total Infection on a lone user (u1) but not on another lone user (u2)", function(assert) {
  var u1, u2, users1;
  users1 = new UserBase;
  users1.populateUsers([1, 2]);
  u1 = users1.getUser(1);
  u2 = users1.getUser(2);
  total_infection(u1);
  assert.equal(u1.infected, true, "u1 is infected");
  return assert.equal(u2.infected, false, "u2 is not infected");
});

QUnit.test("Total Infection on Coach (u1) with a Student (u2) but not on a lone user (u3)", function(assert) {
  var u1, u2, u3, users2;
  users2 = new UserBase;
  users2.populateUsers([1, 2, 3]);
  u1 = users2.getUser(1);
  u2 = users2.getUser(2);
  u3 = users2.getUser(3);
  u1.addStudent(u2);
  total_infection(u1);
  assert.equal(u1.infected, true, "u1 is infected");
  assert.equal(u2.infected, true, "u2 is infected");
  return assert.equal(u3.infected, false, "u3 is not infected");
});

QUnit.test("Coach (c1) with Students (s1, s2, s3), Coach (c2) with Students (s4, s5), Total Infection on s3", function(assert) {
  var c1, c2, s1, s2, s3, s4, s5, users;
  users = new UserBase;
  users.populateUsers([1, 2, 3, 4, 5, 6, 7]);
  c1 = users.getUser(1);
  c2 = users.getUser(2);
  s1 = users.getUser(3);
  s2 = users.getUser(4);
  s3 = users.getUser(5);
  s4 = users.getUser(6);
  s5 = users.getUser(7);
  c1.addStudents([s1, s2, s3]);
  c2.addStudents([s4, s5]);
  total_infection(s3);
  assert.equal(c1.infected, true, "c1 is infected");
  assert.equal(s1.infected, true, "s1 is infected");
  assert.equal(s2.infected, true, "s2 is infected");
  assert.equal(s3.infected, true, "s3 is infected");
  assert.equal(c2.infected, false, "c2 is not infected");
  assert.equal(s4.infected, false, "s4 is not infected");
  return assert.equal(s5.infected, false, "s5 is not infected");
});

QUnit.test("Coach (c1) with Students (s1, s2, c2), Coach (c2) with Students (s3, s4, s5), Total Infection on s3", function(assert) {
  var c1, c2, s1, s2, s3, s4, s5, users;
  users = new UserBase;
  users.populateUsers([1, 2, 3, 4, 5, 6, 7]);
  c1 = users.getUser(1);
  c2 = users.getUser(2);
  s1 = users.getUser(3);
  s2 = users.getUser(4);
  s3 = users.getUser(5);
  s4 = users.getUser(6);
  s5 = users.getUser(7);
  c1.addStudents([s1, s2, c2]);
  c2.addStudents([s3, s4, s5]);
  total_infection(s3);
  assert.equal(c1.infected, true, "c1 is infected");
  assert.equal(c2.infected, true, "c2 is infected");
  assert.equal(s1.infected, true, "s1 is infected");
  assert.equal(s2.infected, true, "s2 is infected");
  assert.equal(s3.infected, true, "s3 is infected");
  assert.equal(s4.infected, true, "s4 is infected");
  assert.equal(s5.infected, true, "s5 is infected");
  assert.equal(c1.infectedStudents(), 6, "c1 reports 6 infected students");
  return assert.equal(c2.infectedStudents(), 3, "c2 reports 3 infected students");
});

QUnit.test("Total Infection with Large, Complex Dataset (1000 Users)", function(assert) {
  var c1, c2, c3, c4, c5, users, _i, _j, _k, _l, _m, _n, _results, _results1, _results2, _results3, _results4, _results5;
  users = new UserBase;
  users.populateUsers((function() {
    _results = [];
    for (_i = 1; _i <= 1000; _i++){ _results.push(_i); }
    return _results;
  }).apply(this));
  c1 = users.getUser(1);
  c2 = users.getUser(2);
  c3 = users.getUser(3);
  c4 = users.getUser(4);
  c5 = users.getUser(5);
  c1.addStudents(users.getUsers((function() {
    _results1 = [];
    for (_j = 6; _j <= 100; _j++){ _results1.push(_j); }
    return _results1;
  }).apply(this)));
  c1.addStudents([c2, c3]);
  c2.addStudents(users.getUsers((function() {
    _results2 = [];
    for (_k = 101; _k <= 300; _k++){ _results2.push(_k); }
    return _results2;
  }).apply(this)));
  c3.addStudents(users.getUsers((function() {
    _results3 = [];
    for (_l = 101; _l <= 200; _l++){ _results3.push(_l); }
    return _results3;
  }).apply(this)));
  c3.addStudents([c4, c5]);
  c4.addStudents(users.getUsers((function() {
    _results4 = [];
    for (_m = 301; _m <= 400; _m++){ _results4.push(_m); }
    return _results4;
  }).apply(this)));
  c5.addStudents(users.getUsers((function() {
    _results5 = [];
    for (_n = 401; _n <= 500; _n++){ _results5.push(_n); }
    return _results5;
  }).apply(this)));
  assert.equal(users.infectedUsersCount(), 0, "User base reports correct infected count before infection");
  total_infection(users.getUser(694));
  assert.equal(users.infectedUsersCount(), 1, "User base reports correct infected count after first infection");
  total_infection(users.getUser(230));
  assert.equal(users.infectedUsersCount(), 501, "User base reports correct infected count after both infections");
  assert.equal(c1.infectedStudents(), 499, "Test Coach 1 reports correct number infected students");
  return assert.equal(c3.infectedStudents(), 302, "Test Coach 2 reports correct number infected students");
});

QUnit.test("Limited Infection (C, 6) on Coach (C) with 3 Students", function(assert) {
  var c, numInfected, users;
  users = new UserBase;
  users.populateUsers([1, 2, 3, 4]);
  c = users.getUser(1);
  c.addStudents(users.getUsers([2, 3, 4]));
  numInfected = limited_infection(c, 6);
  assert.equal(c.infected, true, "Coach C is infected");
  assert.equal(c.percentInfectedStudents(), 100, "100% of coach's students are infected");
  return assert.equal(numInfected, 4, "4 users infected");
});

QUnit.test("Limited Infection (A, 6) for 3 Coaches with 3 Students Each", function(assert) {
  var c1, c2, c3, users;
  users = new UserBase;
  users.populateUsers([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
  c1 = users.getUser(1);
  c2 = users.getUser(2);
  c3 = users.getUser(3);
  c1.addStudents(users.getUsers([4, 5, 6]));
  c2.addStudents(users.getUsers([7, 8, 9]));
  c3.addStudents(users.getUsers([10, 11, 12]));
  limited_infection(c1, 6);
  assert.equal(c1.infected, true, "Coach A is infected");
  assert.equal(c1.percentInfectedStudents(), 100, "All of Coach A's students are infected");
  assert.equal(c2.infected, true, "Coach B is infected");
  assert.equal(c2.percentInfectedStudents(), 100, "All of Coach B's students are infected");
  assert.equal(c3.infected, false, "Coach C is not infected");
  return assert.equal(c3.percentInfectedStudents(), 0, "None of Coach C's students are infected");
});

QUnit.test("Limited Infection (C, 1) where A coaches B and B coaches C", function(assert) {
  var c1, c2, s3, users;
  users = new UserBase;
  users.populateUsers([1, 2, 3]);
  c1 = users.getUser(1);
  c2 = users.getUser(2);
  s3 = users.getUser(3);
  c1.addStudent(c2);
  c2.addStudent(s3);
  limited_infection(s3, 1);
  assert.equal(c1.infected, false, "A is not infected");
  assert.equal(c1.percentInfectedStudents(), 50, "Half of A's students are infected");
  assert.equal(c2.infected, false, "B is not infected");
  assert.equal(c2.percentInfectedStudents(), 100, "All of B's students are infected");
  return assert.equal(s3.infected, true, "C is infected");
});

QUnit.test("Limited Infection (C, 2) where A coaches B and B coaches C", function(assert) {
  var c1, c2, s3, users;
  users = new UserBase;
  users.populateUsers([1, 2, 3]);
  c1 = users.getUser(1);
  c2 = users.getUser(2);
  s3 = users.getUser(3);
  c1.addStudent(c2);
  c2.addStudent(s3);
  limited_infection(s3, 2);
  assert.equal(c1.infected, false, "A is not infected");
  assert.equal(c1.percentInfectedStudents(), 100, "All of Coach A's students are infected");
  assert.equal(c2.infected, true, "B is infected");
  assert.equal(c2.percentInfectedStudents(), 100, "All of Coach B's students are infected");
  return assert.equal(s3.infected, true, "C is infected");
});

QUnit.test("Limited Infection (C, 3) where A coaches B and B coaches C", function(assert) {
  var c1, c2, s3, users;
  users = new UserBase;
  users.populateUsers([1, 2, 3]);
  c1 = users.getUser(1);
  c2 = users.getUser(2);
  s3 = users.getUser(3);
  c1.addStudent(c2);
  c2.addStudent(s3);
  limited_infection(s3, 3);
  assert.equal(c1.infected, true, "A is infected");
  assert.equal(c2.infected, true, "B is infected");
  return assert.equal(s3.infected, true, "C is infected");
});

QUnit.test("Limited Infection with Large, Complex Dataset (1000 Users)", function(assert) {
  var infected, u11, u12, u13, u14, u15, u16, u3, u5, users, _i, _j, _k, _l, _m, _n, _o, _p, _results, _results1, _results2, _results3, _results4, _results5, _results6, _results7;
  users = new UserBase;
  users.populateUsers((function() {
    _results = [];
    for (_i = 1; _i <= 1000; _i++){ _results.push(_i); }
    return _results;
  }).apply(this));
  u3 = users.getUser(3);
  u5 = users.getUser(5);
  u11 = users.getUser(11);
  u12 = users.getUser(12);
  u13 = users.getUser(13);
  u14 = users.getUser(14);
  u15 = users.getUser(15);
  u16 = users.getUser(16);
  u3.addStudents(users.getUsers((function() {
    _results1 = [];
    for (_j = 17; _j <= 100; _j++){ _results1.push(_j); }
    return _results1;
  }).apply(this)));
  u3.addStudents([u11, u12]);
  u5.addStudents(users.getUsers((function() {
    _results2 = [];
    for (_k = 301; _k <= 400; _k++){ _results2.push(_k); }
    return _results2;
  }).apply(this)));
  u11.addStudents(users.getUsers((function() {
    _results3 = [];
    for (_l = 101; _l <= 200; _l++){ _results3.push(_l); }
    return _results3;
  }).apply(this)));
  u12.addStudents(users.getUsers((function() {
    _results4 = [];
    for (_m = 201; _m <= 300; _m++){ _results4.push(_m); }
    return _results4;
  }).apply(this)));
  u16.addCoaches(users.getUsers([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
  u13.addStudent(u14);
  u13.addStudents(users.getUsers((function() {
    _results5 = [];
    for (_n = 851; _n <= 900; _n++){ _results5.push(_n); }
    return _results5;
  }).apply(this)));
  u14.addStudents(users.getUsers((function() {
    _results6 = [];
    for (_o = 901; _o <= 950; _o++){ _results6.push(_o); }
    return _results6;
  }).apply(this)));
  u15.addStudents(users.getUsers((function() {
    _results7 = [];
    for (_p = 951; _p <= 1000; _p++){ _results7.push(_p); }
    return _results7;
  }).apply(this)));
  assert.equal(users.infectedUsersCount(), 0, "User base reports correct infected count before infection");
  infected = limited_infection(users.getUser(9), 110);
  return assert.equal(infected, 110, "Correct number of users infected");
});
