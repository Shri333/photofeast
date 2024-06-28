const cookies = '''
{
  "name": "Vegan Peanut Butter Chocolate Chip Cookies",
  "description": "Delicious and chewy vegan peanut butter chocolate chip cookies. Perfect for a sweet treat without any animal products.",
  "servings": 24,
  "prep_time": "15 minutes",
  "cook_time": "10 minutes",
  "ingredients": [
    {
      "name": "Peanut Butter",
      "quantity": "1 cup"
    },
    {
      "name": "Sugar",
      "quantity": "1 cup"
    },
    {
      "name": "Brown Sugar",
      "quantity": "1 cup"
    },
    {
      "name": "Vanilla Extract",
      "quantity": "1 tsp"
    },
    {
      "name": "Flax Eggs",
      "quantity": "2"
    },
    {
      "name": "All-purpose Flour",
      "quantity": "2 cups"
    },
    {
      "name": "Baking Soda",
      "quantity": "1 tsp"
    },
    {
      "name": "Salt",
      "quantity": "1/2 tsp"
    },
    {
      "name": "Vegan Chocolate Chips",
      "quantity": "1 cup"
    }
  ],
  "steps": [
    {
      "number": 1,
      "description": "Preheat oven to 350°F (175°C)."
    },
    {
      "number": 2,
      "description": "In a large bowl, cream together the peanut butter, sugar, and brown sugar until smooth."
    },
    {
      "number": 3,
      "description": "Beat in the vanilla extract and flax eggs one at a time."
    },
    {
      "number": 4,
      "description": "In a separate bowl, whisk together the flour, baking soda, and salt."
    },
    {
      "number": 5,
      "description": "Gradually blend the dry ingredients into the peanut butter mixture."
    },
    {
      "number": 6,
      "description": "Stir in the vegan chocolate chips."
    },
    {
      "number": 7,
      "description": "Drop rounded spoonfuls of dough onto ungreased cookie sheets."
    },
    {
      "number": 8,
      "description": "Bake for 8 to 10 minutes, or until edges are lightly browned."
    },
    {
      "number": 9,
      "description": "Allow cookies to cool on baking sheet for 5 minutes before transferring to a wire rack to cool completely."
    }
  ]
}
''';

const sandwiches = '''
{
  "name": "Vegan Peanut Butter Chocolate Chip Sandwiches",
  "description": "A delightful and easy-to-make vegan snack combining the flavors of peanut butter and chocolate chips between slices of bread.",
  "servings": 4,
  "prep_time": "10 minutes",
  "cook_time": "0 minutes",
  "ingredients": [
    {
      "name": "Peanut Butter",
      "quantity": "1/2 cup"
    },
    {
      "name": "Vegan Chocolate Chips",
      "quantity": "1/4 cup"
    },
    {
      "name": "Whole Grain Bread",
      "quantity": "8 slices"
    },
    {
      "name": "Banana",
      "quantity": "1, sliced"
    }
  ],
  "steps": [
    {
      "number": 1,
      "description": "Spread a layer of peanut butter on one side of each slice of bread."
    },
    {
      "number": 2,
      "description": "Sprinkle vegan chocolate chips over the peanut butter on four of the slices."
    },
    {
      "number": 3,
      "description": "Top the chocolate chips with banana slices."
    },
    {
      "number": 4,
      "description": "Place the remaining four slices of bread on top to form sandwiches."
    },
    {
      "number": 5,
      "description": "Cut each sandwich in half and serve."
    }
  ]
}
''';

const pudding = '''
{
  "name": "Vegan Peanut Butter Chocolate Chip Bread Pudding",
  "description": "A rich and comforting vegan bread pudding with peanut butter and chocolate chips. Perfect for dessert or breakfast.",
  "servings": 8,
  "prep_time": "20 minutes",
  "cook_time": "40 minutes",
  "ingredients": [
    {
      "name": "Stale Bread",
      "quantity": "6 cups, cubed"
    },
    {
      "name": "Peanut Butter",
      "quantity": "1/2 cup"
    },
    {
      "name": "Vegan Chocolate Chips",
      "quantity": "1/2 cup"
    },
    {
      "name": "Almond Milk",
      "quantity": "2 cups"
    },
    {
      "name": "Maple Syrup",
      "quantity": "1/4 cup"
    },
    {
      "name": "Vanilla Extract",
      "quantity": "1 tsp"
    },
    {
      "name": "Cinnamon",
      "quantity": "1 tsp"
    },
    {
      "name": "Ground Flaxseed",
      "quantity": "2 tbsp"
    },
    {
      "name": "Water",
      "quantity": "6 tbsp"
    }
  ],
  "steps": [
    {
      "number": 1,
      "description": "Preheat oven to 350°F (175°C)."
    },
    {
      "number": 2,
      "description": "In a small bowl, mix ground flaxseed with water and let sit for 5 minutes to thicken."
    },
    {
      "number": 3,
      "description": "In a large bowl, whisk together almond milk, peanut butter, maple syrup, vanilla extract, and cinnamon until smooth."
    },
    {
      "number": 4,
      "description": "Add the flaxseed mixture to the almond milk mixture and stir to combine."
    },
    {
      "number": 5,
      "description": "Add the bread cubes and vegan chocolate chips to the mixture, stirring gently to coat the bread."
    },
    {
      "number": 6,
      "description": "Pour the mixture into a greased baking dish and press down lightly to ensure all the bread is soaked."
    },
    {
      "number": 7,
      "description": "Bake for 35-40 minutes, or until the top is golden brown and the pudding is set."
    },
    {
      "number": 8,
      "description": "Allow to cool for 10 minutes before serving."
    }
  ]
}
''';

const sampleRecipes = '''
{
  "recipes": [
    $cookies,
    $sandwiches,
    $pudding
  ]
}
''';
