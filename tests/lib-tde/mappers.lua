local mappers = require("tde.lib-tde.mappers")

local function compare_list(first, second)
    assert(#first == #second, "Arrays are not the same length")
    for index, element in ipairs(first) do
        assert(element == second[index], "Values in index " .. index .. " are not the same for both arrays")
    end
end

function test_mappers_mapping_basics()
    local list = {1, 2, 3}
    local result =
        mappers.map(
        list,
        function(element, _)
            return element * 2
        end
    )
    local expected = {2, 4, 6}
    compare_list(result, expected)
end

function test_mappers_mapping_with_index()
    local list = {1, 2, 3, 5}
    local result =
        mappers.map(
        list,
        function(element, index)
            return element * index
        end
    )
    local expected = {1, 4, 9, 20}
    compare_list(result, expected)
end

function test_mappers_mapping_with_string()
    local list = {"A", "B", "C"}
    local result =
        mappers.map(
        list,
        function(element, _)
            return element .. "E"
        end
    )
    local expected = {"AE", "BE", "CE"}
    compare_list(result, expected)
end

function test_mappers_filter_basics()
    local list = {1, 2, 3, 5, 7, 9, 10}
    local result =
        mappers.filter(
        list,
        function(element, _)
            return element < 7
        end
    )
    local expected = {1, 2, 3, 5}
    compare_list(result, expected)
end

function test_mappers_filter_basics_with_string()
    local list = {"a", "b", "c", "d"}
    local result =
        mappers.filter(
        list,
        function(element)
            return element < "c"
        end
    )
    local expected = {"a", "b"}
    compare_list(result, expected)
end

function test_mapper_reducer_basics()
    local list = {1, 2, 3, 4}
    local result =
        mappers.reduce(
        list,
        function(acc, element)
            return acc + element
        end,
        0
    )
    assert(result == 10)
end

function test_mapper_reducer_basics_with_initial_value()
    local list = {1, 2, 3, 4}
    local result =
        mappers.reduce(
        list,
        function(acc, element)
            return acc + element
        end,
        30
    )
    assert(result == 40)
end

function test_mapper_reducer_basics_with_index()
    local list = {1, 2, 3, 4}
    local result =
        mappers.reduce(
        list,
        function(acc, element, index)
            return acc + element + index
        end,
        0
    )
    assert(result == 20)
end

function test_mapper_reducer_with_string()
    local list = {"a", "b", "c"}
    local result =
        mappers.reduce(
        list,
        function(acc, element)
            return acc .. element
        end,
        ""
    )
    assert(result == "abc")
end

function test_mapper_contains_basic()
    local list = {1, 2, 3, 4, 5}
    local result =
        mappers.contains(
        list,
        function(element)
            return element == 4
        end
    )
    assert(result)
end

function test_mapper_contains_basic_not_exists()
    local list = {1, 2, 3, 4, 5}
    local result =
        mappers.contains(
        list,
        function(element)
            return element == 9
        end
    )
    assert(not result)
end

function test_mapper_contains_basic_not_exists_index()
    local list = {1, 2, 3, 4, 5}
    local result =
        mappers.contains(
        list,
        function(_, index)
            return index > 10
        end
    )
    assert(not result)
end

function test_mapper_contains_string()
    local list = {"A", "B", "C"}
    local result =
        mappers.contains(
        list,
        function(element)
            return element == "a"
        end
    )
    assert(not result)
end

function test_mapper_contains_string()
    local list = {"A", "B", "C", "a", "b", "c"}
    local result =
        mappers.contains(
        list,
        function(element)
            return element == "a"
        end
    )
    assert(result)
end

function test_mappers_api_is_correct()
    assert(type(mappers.map) == "function")
    assert(type(mappers.filter) == "function")
    assert(type(mappers.reduce) == "function")
    assert(type(mappers.contains) == "function")
end