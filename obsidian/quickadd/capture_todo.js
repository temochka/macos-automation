module.exports = async (ctx) => {
    const todo = await ctx.quickAddApi.inputPrompt('TODO:');
    const filename = todo
        .replace(/\[\[(.+?)\]\]/g, '$1')
        .replace(/\[(.+?)\]\(.*?\)/g, '$1')
        .replace(/[\:#/➕✅]/g, '');
    const truncatedFilename =
        filename.length > 64 ?
            filename.slice(0, 61) : filename;

    ctx.variables["filename"] = truncatedFilename;
    ctx.variables["todo"] = todo;
};
