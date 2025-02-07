from math import sin,cos,radians,atan2,sqrt
import random
from typing import Self

""" This is the model of the game"""
class Game:
    """ Create a game with a given size of cannon (length of sides) and projectiles (radius) """
    def __init__(self: Self, cannonSize: float, ballSize: float):
        self.cannonSize: float = cannonSize
        self.ballSize: float = ballSize

        self.players: List[Player] = [Player(self, False, -90, "blue"), Player(self, True, 90, "red")]
        self.currentPlayerNumber: int = 0

        self.wind: float = 0
        self.newRound()

    """ A list containing both players """
    def getPlayers(self: Self):
        return self.players

    """ The height/width of the cannon """
    def getCannonSize(self: Self):
        return self.cannonSize

    """ The radius of cannon balls """
    def getBallSize(self: Self):
        return self.ballSize

    """ The current player, i.e. the player whose turn it is """
    def getCurrentPlayer(self: Self):
        return self.players[self.currentPlayerNumber]

    """ The opponent of the current player """
    def getOtherPlayer(self: Self):
        return self.players[(self.currentPlayerNumber + 1) % len(self.players)]
    
    """ The number (0 or 1) of the current player. This should be the position of the current player in getPlayers(). """
    def getCurrentPlayerNumber(self: Self):
        return self.currentPlayerNumber
    
    """ Switch active player """
    def nextPlayer(self: Self):
        self.currentPlayerNumber = (self.currentPlayerNumber + 1) % 2

    """ Set the current wind speed, only used for testing """
    def setCurrentWind(self: Self, wind: float):
        self.wind = wind

    
    def getCurrentWind(self: Self):
        return self.wind

    """ Start a new round with a random wind value (-10 to +10) """
    def newRound(self: Self):
        #HINT: random.random() gives a random value between 0 and 1
        # multiplying this by 20 gives a random value between 0 and 20
        # how do you shift a value between 0 and 20 to one between -10 and +10?
        self.wind = random.random() * 20 - 10

""" Models a projectile (a cannonball, but could be used more generally) """
class Projectile:
    """
        Constructor parameters:
        angle and velocity: the initial angle and velocity of the projectile 
            angle 0 means straight east (positive x-direction) and 90 straight up
        wind: The wind speed value affecting this projectile
        xPos and yPos: The initial position of this projectile
        xLower and xUpper: The lowest and highest x-positions allowed
    """
    def __init__(self, angle, velocity, wind, xPos, yPos, xLower, xUpper):
        self.yPos = yPos
        self.xPos = xPos
        self.xLower = xLower
        self.xUpper = xUpper
        theta = radians(angle)
        self.xvel = velocity*cos(theta)
        self.yvel = velocity*sin(theta)
        self.wind = wind


    """ 
        Advance time by a given number of seconds
        (typically, time is less than a second, 
         for large values the projectile may move erratically)
    """
    def update(self: Self, time: float):
        # Compute new velocity based on acceleration from gravity/wind
        yvel1 = self.yvel - 9.8*time
        xvel1 = self.xvel + self.wind*time
        
        # Move based on the average velocity in the time period
        self.xPos = self.xPos + time * (self.xvel + xvel1) / 2.0
        self.yPos = self.yPos + time * (self.yvel + yvel1) / 2.0
        
        # make sure yPos >= 0
        self.yPos = max(self.yPos, 0)
        
        # Make sure xLower <= xPos <= mUpper
        self.xPos = max(self.xPos, self.xLower)
        self.xPos = min(self.xPos, self.xUpper)
        
        # Update velocities
        self.yvel = yvel1
        self.xvel = xvel1
        
    """ A projectile is moving as long as it has not hit the ground or moved outside the xLower and xUpper limits """
    def isMoving(self: Self):
        return 0 < self.getY() and self.xLower < self.getX() < self.xUpper

    def getX(self: Self):
        return self.xPos

    """ The current y-position (height) of the projectile. Should never be below 0. """
    def getY(self: Self):
        return self.yPos
    
    def getPosition(self: Self) -> tuple[float, float]:
        return (self.getX(), self.getY())


""" Models a player """
class Player:
    """
        Constructor parameters:
        game: the game that this is part of
        isReversed: whether this player is aiming to the left
        xPos: the x-position of the centre of the cannon
        color: the color of the cannon
    """
    def __init__(self: Self, game: Game, isReversed: bool, xPos: float, color: str):
        # Properties
        self.__game: Game = game
        self.isReversed: bool = isReversed
        self.xPos: float = xPos
        self.color: str = color
        
        # State
        self.score: int = 0
        self.aim: tuple[float, float] = (45, 40)
        self.projectile: Projectile | None = None

    """ Create and return a projectile starting at the centre of this players cannon. Replaces any previous projectile for this player. """
    def fire(self: Self, angle: float, velocity: float) -> Projectile:
        self.aim = (angle, velocity)
        self.projectile = Projectile(180 - angle if self.isReversed else angle, velocity, self.__game.wind, self.getPosition()[0], self.getPosition()[1], -110, 110)
        return self.projectile

    """ Gives the x-distance from this players cannon to a projectile. If the cannon and the projectile touch (assuming the projectile is on the ground and factoring in both cannon and projectile size) this method should return 0"""
    def projectileDistance(self: Self, proj: Projectile):
        diff = proj.getPosition()[0] - self.getPosition()[0]
        if abs(diff) < self.__game.getCannonSize() / 2 + self.__game.getBallSize():
            return 0
        return (1 if diff > 0 else -1) *( abs(diff) - self.__game.getCannonSize() / 2 - self.__game.getBallSize())

    def projectile2DDistance(self: Self, proj: Projectile):
        centerDist = (self.getPosition()[0] - proj.getPosition()[0], self.getPosition()[1] - proj.getPosition()[1])
        angleBetween = atan2(centerDist[1], centerDist[0])
        boxSize = self.__game.getCannonSize() / 2 / max(abs(cos(angleBetween)), abs(sin(angleBetween)))

    """ The current score of this player """
    def getScore(self: Self):
        return self.score

    """ Increase the score of this player by 1."""
    def increaseScore(self: Self):
        self.score += 1

    """ Returns the color of this player (a string)"""
    def getColor(self: Self):
        return self.color

    """ The x-position of the centre of this players cannon """
    def getX(self: Self):
        return self.xPos
    
    def getPosition(self: Self) -> tuple[float, float]:
        return (self.getX(), self.__game.getCannonSize() / 2)

    """ The angle and velocity of the last projectile this player fired, initially (45, 40) """
    def getAim(self: Self):
        return self.aim

    def getActualAim(self: Self) -> tuple[float, float]: 
        return (self.aim[0] * (-1 if self.isReversed else 1), self.aim[1])


