import io
import sys
import importlib.util

def test(res,msg):
    global pass_tests, fail_tests
    if res:
        pass_tests = pass_tests + 1
    else:
        print(msg)
        fail_tests = fail_tests + 1

def runTests(game):
    players = game.getPlayers()

    test(len(players) == 2, "there should be two players")

    test(players[0].getColor() == "blue", "player 0 should be blue!")
    test(players[1].getColor() == "red", "player 1 should be red!")

    test(players[0].getX() == -90, "player 0 should stand at x=-90!")
    test(players[1].getX() ==  90, "player 1 should stand at x=90!")

    test(game.getCurrentPlayerNumber() == 0, "player 0 should start!")

    test(game.getCurrentPlayer() == players[0], "player 0 should start! (2)")
    test(game.getOtherPlayer() == players[1], "getOtherPlayer() doesn't work")

    # Testing manually swapping player
    game.nextPlayer()
    test(game.getCurrentPlayerNumber() == 1, "player 1 should go second!")
    test(game.getCurrentPlayer() == players[1], "player 1 should go second! (2)")
    test(game.getOtherPlayer() == players[0], "getOtherPlayer() doesn't work")

    # Switch back to player 0
    game.nextPlayer()
    test(game.getCurrentPlayer() == players[0], "player 0 should go after player 1!")
    test(game.getOtherPlayer() == players[1], "getOtherPlayer() doesn't work")

    # Test the wind initialization
    test(-10 <= game.getCurrentWind() <= 10, "wind should be a random value in [-10,10]")

    # Turn off wind
    game.setCurrentWind(0)
    test(game.getCurrentWind() == 0, "wind should be 0")
    
    #Testing "Manual fire" for player 0
    proj = game.getCurrentPlayer().fire(30,31)
    test(proj.getX() == game.getCurrentPlayer().getX(), "Fired projectile should start at player X-position")
    test(abs(proj.getY() - 10/2) < 0.01, "Fired projectile Y-position should start half the cannon size")
    test(proj.isMoving() == True, "projectile should be moving")

    test(game.getCurrentPlayer().getAim() == (30,31), "After firing, getAim() should give the latest (angle,velocity)-values")

    proj.update(1.0)
    test(abs(proj.getX() + 63.1532124826824) < 0.01, "Projectile X-Position is {0:f}, should be -63.153212".format(proj.getX()))
    test(abs(proj.getY() - 15.6) < 0.01, "Projectile X-Position is {0:f}, should be 15.6".format(proj.getY()))
    test(proj.isMoving(), "projectile should be moving")

    ticks = 0
    while proj.isMoving():
        proj.update(0.1)
        ticks += 1
        test(ticks <= 25, "projectile should have stopped now...")
    test(ticks == 25, "Incorrect tick-count")

    test(proj.getY() == 0.0, "projectile should stop at y=0")
    test(abs(proj.getX() - 3.9637563106115907) < 0.01, "Projectile X-Position is {0:f}, should be -3.9637563106115907".format(proj.getX()))

    test(abs(players[1].projectileDistance(proj) - -78.03624368938841) < 0.01, "Projectile X-distance to player is {0:f}, should be -78.03624368938841".format(players[1].projectileDistance(proj)))
    test(abs(players[0].projectileDistance(proj) - 85.96375631061159) < 0.01, "Projectile X-distance to player is {0:f}, should be 85.96375631061159".format(players[0].projectileDistance(proj)))

    #Switching to player 1
    game.nextPlayer()
    test(game.getCurrentPlayerNumber() == 1, "player 1 should go after player 0")
    test(game.getCurrentPlayer() == players[1], "player 1 should go after player 0")
    test(game.getOtherPlayer() == players[0], "getOtherPlayer() doesn't work")
    
    #Testing "Manual fire" for player 1
    proj = game.getCurrentPlayer().fire(45,41)
    test(proj.getX() == game.getCurrentPlayer().getX(), "Fired projectile should start at player X-position")
    test(proj.getY() == 10/2, "Fired projectile Y-position should start half the cannon size")
    test(proj.isMoving(), "projectile should be moving")

    ticks = 0
    while proj.isMoving():
        proj.update(0.1)
        ticks += 1
        assert ticks <= 61, "projectile should have stopped now..."
    test(ticks == 61, "Incorrect tick-count")
    test(proj.getY()==0.0, "projectile should always stop at y=0")
    test(abs(proj.getX() - -86.84740597475547) < 0.01, "Projectile X-Position is {0:f}, should be -86.84740597475547".format(proj.getX()))
    test(abs(players[1].projectileDistance(proj) - -168.84740597475547) < 0.01, "Projectile X-distance to player is {0:f}, should be 168.84740597475547".format(players[1].projectileDistance(proj)))
    test(players[0].projectileDistance(proj) == 0, "Projectile X-distance to player is {0:f}, should be 0".format(players[0].projectileDistance(proj)))

    # Test scoring
    test(players[0].getScore()==0, "Initial score should be 0")
    players[0].increaseScore()
    test(players[1].getScore()==0, "Score should be 0")
    test(players[0].getScore()==1, "Score should be 1")

    # Test new round
    game.setCurrentWind(1000)
    test(game.getCurrentWind()==1000, "Failed to set wind speed")
    game.newRound()
    test(game.getCurrentWind()!=1000, "Wind should be randomized each round")

    # Test firing with wind
    game.setCurrentWind(-1)
    proj = players[0].fire(45,41)
    test(proj.getX() == players[0].getX(), "Fired projectile should start at player X-position")
    test(proj.getY() == 10/2, "Fired projectile Y-position should start half the cannon size")
    test(proj.isMoving(), "projectile should be moving")

    ticks = 0
    while proj.isMoving():
        proj.update(0.1)
        ticks += 1
        assert ticks <= 61, "projectile should have stopped now..."
        
    test(ticks == 61, "Incorrect tick-count")
    test(abs(proj.getX() - 68.2424059747553) < 0.01, "Projectile X-Position is {0:f}, should be 68.2424059747553".format(proj.getX()))
    
    # A few additional hints
    gameAtts = len(game.__dict__.items())
    if (gameAtts > 5):
        print("Your Game object has {} attributes. This isn't necessarily wrong, but 5 seems like a nice number.".format(gameAtts))
        print("Make sure you are not representing the same information in multiple attributes.")
    playerAtts = len(game.getCurrentPlayer().__dict__.items())
    if (playerAtts > 8):
        print("Your Player object has {} attributes. This isn't necessarily wrong, but it seems a bit high.".format(playerAtts))

def run(src_path=None):
    global pass_tests, fail_tests

    if src_path == None:
        import gamemodel
    else:
        spec = importlib.util.spec_from_file_location("gamemodel", src_path+"/gamemodel.py")
        gamemodel = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(gamemodel)

    pass_tests = 0
    fail_tests = 0
    fun_count  = 0

    game = gamemodel.Game(10,3)
    runTests(game)

    print(str(pass_tests)+" out of "+str(pass_tests+fail_tests)+" passed.")

    return (fun_count == 0 and fail_tests == 0)

if __name__ == "__main__":
    run()
