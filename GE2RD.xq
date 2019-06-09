declare namespace xsd="http://www.w3.org/2001/XMLSchema";

declare function local:typeFold($root,$t)
{  let $el1 := $root//*[@name=$t]
   return
   if ($el1)  
   then
     element {$el1/name()}
     { if ($el1[xsd:sequence])
       then 
       <sequence>
       { for $el2 in $el1/xsd:sequence/xsd:element
         let $ref := $el2/@ref
         let $el3 := $root//xsd:element[@name=$ref]
         let $type := $el3/@type
         return 
         <xsd:element name="{$ref}">
           { for $ea in $el2/@*
             where name($ea)!="ref"
             return $ea,
             local:typeFold($root,$type) } 
         </xsd:element>
       }   
       { for $el2 in $el1/xsd:attribute
         let $ref := $el2/@ref
         let $el3 := $root//xsd:attribute[@name=$ref]
         let $type := $el3/@type
         let $t1 := $root//*[@name=$type]
         return 
         <xsd:attribute name="{$ref}">
         { for $aa in $el2/@*
           where name($aa)!="ref"
           return $aa,
           if ($t1)
           then $t1
           else attribute {"type"}{$type}
         }
         </xsd:attribute>         
       }   
       </sequence>
       else $el1/*
    }
  else attribute {"type"}{$t} 
};

<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{ for $el in /xsd:schema/xsd:element[@name]
  let $name := $el/@name
  let $type := $el/@type
  where not(//xsd:element[@ref=$name])
  return 
  <xsd:element name="{$name}">
     { local:typeFold(/,$type) } 
  </xsd:element>
}

</xsd:schema>