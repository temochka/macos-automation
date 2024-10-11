const recipeFile = dv.current().file;

const ingredients = [];
const nutritionFacts = {
    calories: 0,
    proteinGrams: 0
};

for (const item of recipeFile.lists) {
    if (!item.servings || !item.outlinks || !item.outlinks[0].path.startsWith('Ingredient/')) {
        continue;
    }
    const page = dv.page(item.outlinks[0].path);
    const servings = `${item.servings * page.serving_size} ${page.unit}`
    ingredients.push({
        page,
        servings
    });
    nutritionFacts.calories += (page.calories ?? 0) * item.servings;
    nutritionFacts.proteinGrams += (page.protein_grams ?? 0) * item.servings;
}

dv.list(ingredients.map(i => `${i.page.file.link} - ${i.servings}`));

dv.table(["Nutrition Facts", "(per serving)"],
    [
        ["Calories", nutritionFacts.calories / recipeFile.frontmatter.servings],
        ["Protein (g)", nutritionFacts.proteinGrams / recipeFile.frontmatter.servings],
    ]
);
