# Возвращает все родительские директории для пути
# @param path Путь
# @return [Array[String]] Родительские директории пути
# @example
#   $parents = vault::parents('a/b/c/d') # => ['a', 'a/b', 'a/b/c']
#   $parents = vault::parents('/a/b/c/d') # => ['/a', '/a/b', '/a/b/c']
function vault::parents(String $path) >> Array[String]
{
  $path_split = split($path, '/')
  if $path[0] == '/' {
    if length($path_split) <= 2 {
      []
    } else {
      $indices = Integer[2, length($path_split)-1]
      $indices.step(1).map |$index| { join($path_split[0, $index], '/') }
    }
  } else {
    if length($path_split) <= 1 {
      []
    } else {
      $indices = Integer[1, length($path_split)-1]
      $indices.step(1).map |$index| { join($path_split[0, $index], '/') }
    }
  }
}
