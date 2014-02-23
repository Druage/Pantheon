function removeItem(model)
    {
        for (var i=model.count - 1; i >= 0; --i)
        {
            console.log(model.get(i).title)
            if (model.get(i)){
                console.log("Found: " + i)
                model.remove(i);
                //restarting is no longer needed, and thus we are more efficient :-)
            }
            else {console.log("didnt work " + i)}
        }
    }
