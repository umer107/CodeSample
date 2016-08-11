var counter = {
  state: 1,
  update: function() {
    this.state++
  }
}

var jumpingCounter = Object.create(counter, {
  update: { value: function() { this.state += 10 } }
})

console.log("counter before " + jumpingCounter.state)
jumpingCounter.update()
console.log("counter after " + jumpingCounter.state)
var EventEmitter = require("events").EventEmitter
var util = require("util")

function House() {
  EventEmitter.call(this)

  var that = this

  this.pleaseOpen = function() {
    that.emit("ring")
  }
}

util.inherits(House, EventEmitter)

var me = {
  onRing: function(ev) {
            console.log("opening door")
          }
}

var myHouse = new House()
myHouse.on("ring", me.onRing)

myHouse.pleaseOpen()
var numbers = [1,2,3,4,5,6]

for(var i = numbers.length-1, si = numbers[i], s = 0; si = numbers[i--];) s += si
console.log("sum for " + numbers + " is " + s)

sum = numbers.reduce(function (a, b) { return a + b }, 0)
console.log("sum for " + numbers + " is " + sum)

var result = numbers.map(function(number) {
  return (number * 2)
}).filter(function(e) {
  return (e % 2) === 0
}).reduce(function(acc, val) {
  return acc + val
})

console.log("calculation result: " + result)
var util = require("util")

var Orc = {
  init: function (name, weapon) {
    this.name = name
    this.weapon = weapon
    return this
  },

  get isArmed () { return !!this.weapon },

  attack: function (opponent) {
    console.log(this.name + " strikes "
        + opponent.name + " with " + this.weapon + ".")
  }
}

var Fight = {
  init: function (orc, attacker) {
    this.orc = orc
    this.attacker = attacker
    return this
  },

  round: function () {
     if(this.orc.isArmed) {
       this.orc.attack(this.attacker)
     } else {
       this.attacker.attack(this.orc)
     }
   }
}

var asLoggable = function () {
  Object.keys(this).forEach(function (key) {
    if (this.hasOwnProperty(key) && typeof this[key] === 'function') {
      var that = this
      var fn = this[key]
      this[key] = function () {
        console.log("Called " + key + " on " + util.inspect(that) + " with " + util.inspect(arguments))
        return fn.apply(that, arguments)
      }
    }
  }, this)
  return this
}

var agronak = Object.create(Orc).init("Agronak", "sword")
var traugh = Object.create(Orc).init("Traugh")

var LoggableFight = asLoggable.call(Fight)
var fight = Object.create(LoggableFight).init(agronak, traugh)
fight.round()
