import turtle

def star(color, sides, length, angle, distance):
    galileo = turtle.Turtle()
    galileo.color(color)  # colorful!
    galileo.width(5)  # visible!
    galileo.speed(0)  # fast!
    galileo.penup()
    galileo.left(angle)  # away from center
    galileo.forward(distance)
    galileo.pendown()  # start drawing
    for side in range(sides):
        galileo.forward(length)
        galileo.left(720 / sides)
    galileo.hideturtle()  # just the star

for angle in [180, 135, 90, 45, 0]:
    star("red", 5, 50, angle, 100)

for angle in [180, 135, 90, 45, 0]:
    star("blue", 5, 30, angle, 60)
