declare namespace xsd="http://www.w3.org/2001/XMLSchema";

declare namespace functx = "http://www.functx.com";

declare function functx:index-of-node
  ( $nodes as node()* ,
    $nodeToFind as node() )  as xs:integer* {

  for $seq in (1 to count($nodes))
  return $seq[$nodes[$seq] is $nodeToFind]
 } ;

declare function functx:path-to-node-with-pos
  ( $node as node()? )  as xs:string {

string-join(
  for $ancestor in $node/ancestor-or-self::*
  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
  return concat(name($ancestor),
   if (count($sibsOfSameName) <= 1)
   then ''
   else concat(
      '[',functx:index-of-node($sibsOfSameName,$ancestor),']'))
 , '/')
 } ;

declare function local:change($node,$rl)
{
   typeswitch($node)
      case $e as element(xsd:element)
         return
            element {name($e)}
                    {for $a in $e/@*
                         let $p := functx:path-to-node-with-pos($e)
                         let $newName := $rl/renameItem[path eq $p]/newName                         
                         return if ($a/name()="name" and $newName) 
                            then attribute {"name"}{$newName}
                            else $a,       
                     for $c in $e/(* | text())
                         return local:change($c,$rl) }         
      case $e as element(xsd:attribute)
         return
            element {name($e)}
                    {for $a in $e/@*
                         let $p := functx:path-to-node-with-pos($e)
                         let $newName := $rl/renameItem[path eq $p]/newName                         
                         return if ($a/name()="name" and $newName) 
                            then attribute {"name"}{$newName}
                            else $a,       
                     for $c in $e/(* | text())
                         return local:change($c,$rl) }         
      case $e as element()
         return
            element {name($e)}
                    {$e/@*,
                     for $c in $e/(* | text())
                         return local:change($c,$rl) }         
      default return $node
};

declare function local:setRenameList($doc)
{ <renameList>
{for $j in distinct-values($doc//xsd:element/@name)
return
if (count ($doc//xsd:element[@name=$j])>1) 
  then (
          for $i at $q in $doc//xsd:element[@name=$j]
             return <renameItem> <newName> {fn:concat($j,fn:concat("_", xs:string($q)))}</newName>
                    <path> {functx:path-to-node-with-pos($i)} </path> </renameItem>
        ) else (), 
for $j in distinct-values($doc//xsd:attribute/@name)
return 
if (count ($doc//xsd:attribute[@name=$j])>1) 
  then (
          for $i at $q in $doc//xsd:attribute[@name=$j]
             return <renameItem> <newName> {fn:concat($j,fn:concat("_", xs:string($q)))}</newName>
                    <path> {functx:path-to-node-with-pos($i)} </path> </renameItem>
        ) else () }
</renameList>
};


<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{
let $doc := /*
let $renameList := local:setRenameList($doc)

return local:change($doc,$renameList)
}

{
let $doc := /*
let $renameList := local:setRenameList($doc)

for $ri in $renameList/renameItem
return comment { fn:concat(fn:concat($ri/newName,"="),$ri/path) }

}



</xsd:schema>