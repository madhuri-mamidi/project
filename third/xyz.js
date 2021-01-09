var objectData = {"a": {"b": {"c": "d"}}}

function getValue(obj, key) {
    return key.split("/").reduce(function(result, key) {
       return result[key] 
    }, obj);
}
console.log(getValue(objectData, "a/b/c"));
