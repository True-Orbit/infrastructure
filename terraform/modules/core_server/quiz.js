public abstract class Shape {
  constructor(name) {
    this.name = name;
  }

  draw() {
    # some implementation
  }
}

class Circle extends Shape {
  constructor(name) {
    super(name);
  }

  draw() {
    console.log('Circle');
  }
}

class Square extends Shape {
  constructor(name) {
    super(name);
  }

  draw() {
    console.log('Square');
  }
}

class Rectangle extends Shape {
  constructor(name) {
    super(name);
  }

  draw() {
    console.log('Rectangle');
  }
}


class Triangle extends Shape {
  constructor(name) {
    super(name);
  }

  draw() {
    console.log('Triangle');
  }
}

class abstract ShapeFactory {
  public static Shape createShape(String shapeType) {
    switch (shapeType) {
      case 'Circle':
        return new Circle();
      case 'Rectangle':
        return new Rectangle();
      case 'Triange':
        return new Triangle();
      case 'Square':
        return new Square();
    } 
  }
}



Circle myCircle = ShapeFactory.createShape('Circle')
Rectangle myRectangle = ShapeFactory.createShape('Circle')
Square mySquare = ShapeFactory.createShape('Square')
Triangle myTriangle = ShapeFactory.createShape('Triangle')

Array shapes = [myCircle, myRectangle, mySquare, myTriangle]

for (i = 0; i < shapes.length; i++) {
  shape.draw();
}



