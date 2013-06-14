
import io/File
import text/StringTokenizer
import structs/List

main: func {
    content := File new("words.txt") read()
    tokens := content split(',')
    cleaned := tokens map(|x| x trim() toLower())
    filtered := cleaned filter(|x| x size >= 3)
    quoted := filtered map(|x|
        "\"%s\"" format(x)
    )
    result := quoted join(", ")
    "{ \"words\": [%s] }" printfln(result)
}
