declare namespace xsd="http://www.w3.org/2001/XMLSchema";

declare function local:procSequence($root,$s)
{ let $se := $root//$s
  let $sename := $se/name() (: can be xs:sequence or xs:choice or xs:all :)
  return
  element {$sename}
    { local:addAnnotation($root,$se),

      for $el in $se/*
      return
      if ($el/name()="xsd:element")
      then local:procElement($root,$el)
      else if ($el/name()="xsd:sequence" or $el/name()="xsd:choice")
      then local:procSequence($root,$el)
      else if ($el/name()="xsd:group")
      then local:procGroup($root,$el)
      else $el (: should only be <xsd:any/> if the schema is correct :)
   }
};

(: assuming the schema is correct, there is no need for a management 
   of xsd:all distinct from the management of xsd:sequence or xsd:choice :)

declare function local:procElement($root,$e)
{ let $el := $root//$e 
  return
    if ($el[@ref]) then $el
    else <xsd:element ref="{$el/@name}">
    { local:addAttributes($root,$el), 
      local:addAnnotation($root,$el)
    }
    </xsd:element>
};

declare function local:procAttribute($root,$a)
{ let $at := $root//$a 
  return
    if ($at[@ref]) then $at
    else <xsd:attribute ref="{$at/@name}"> 
    { local:addAttributes($root,$at), 
      local:addAnnotation($root,$at) }
    </xsd:attribute>
};

declare function local:procAttributes($root,$c)
{ let $ct := $root//$c 
  for $at in $ct/xsd:attribute
      return local:procAttribute($root,$at),
  let $ct := $root//$c
  for $ag in $ct/xsd:attributeGroup
      return local:procGroup($root,$ag),
  let $ct := $root//$c
  return
  if ($ct[xsd:anyAttribute]) 
      then $ct/xsd:anyAttribute else ()
};

declare function local:groupNameList($root,$g)
{ let $gr := $root//$g
  for $el in $gr//xsd:element
  return if ($el[@name]) then substring($el/@name,1,2)
                         else substring($el/@ref,1,2),
  "Group"
};

declare function local:createAttributeGroupName($root,$g)
{ let $gr := $root//$g
  let $names := local:AttributeGroupNameList($root,$gr)
  return string-join($names,"")
};

declare function local:AttributeGroupNameList($root,$g)
{ let $gr := $root//$g
  for $at in $gr//xsd:attribute
  return if ($at[@name]) then substring($at/@name,1,2)
                         else substring($at/@ref,1,2),
  "Group"
};

declare function local:createGroupName($root,$g)
{ let $gr := $root//$g
  let $names := local:groupNameList($root,$gr)
  return string-join($names,"")
};

declare function local:addAttributes($root,$e)
{ let $el := $root//$e
  for $ea in $el/@*
  where name($ea)!="name" and name($ea)!="type"
  return $ea
};

declare function local:addAttributesExceptMinAndMaxOccurs($root,$e)
{ let $el := $root//$e
  for $ea in $el/@*
  where name($ea)!="name" and name($ea)!="type" and name($ea)!="minOccurs" and name($ea)!="maxOccurs"
  return $ea
};

declare function local:addAnnotation($root,$e)
{ let $el := $root//$e
  return if ($el[xsd:annotation]) then $el/xsd:annotation else ()
};

declare function local:procGroup($root,$g)
{ let $gr := $root//$g
  let $grtyp := $gr/name()  (: can be xsd:group or xsd:attributeGroup :)
  return
  if ($gr[@ref])
  then $gr  
  else if ($gr[@name])
  then
    element {$grtyp} { attribute {"ref"} {$gr/@name} }
  else 
  ( let $name := if ($grtyp="xsd:group")
                 then local:createGroupName($root,$gr)
                 else local:createAttributeGroupName($root,$gr)
    return
    element {$grtyp} { attribute {"ref"} {$name} }
  )
};


<xsd:schema>

{ let $sa := /xsd:schema/@*
  return $sa
}

{ let $el := /xsd:schema/(xsd:include|xsd:import|xsd:annotation)
  return $el
}

{ for $ct in //xsd:complexType[xsd:sequence or xsd:choice or xsd:all]
  let $type := if ($ct[@name]) 
               then $ct/@name else concat($ct/../@name,'Type')
  return
  <xsd:complexType name="{$type}">
    { local:addAttributes(/,$ct),
      local:addAnnotation(/,$ct),

      let $se := $ct/(xsd:sequence|xsd:choice|xsd:all)
      return local:procSequence(/,$se),

      local:procAttributes(/,$ct)
    }
  </xsd:complexType>
}

{ for $ct in //xsd:complexType[xsd:complexContent or xsd:simpleContent]
  let $type := if ($ct[@name]) 
               then $ct/@name else concat($ct/../@name,'Type')
  let $contyp := $ct/(xsd:complexContent|xsd:simpleContent)      
  let $cnname := $contyp/name()
  let $elcont := $contyp/(xsd:restriction|xsd:extension)  
  let $elname := $elcont/name()
  let $elbase := $elcont/@base
  return
  <xsd:complexType name="{$type}">
    { local:addAttributes(/,$ct),
      local:addAnnotation(/,$ct)
    }
    { element {$cnname}
      { local:addAttributes(/,$contyp),
        local:addAnnotation(/,$contyp),
        element {$elname} 
        { attribute base {$elbase},
          if ($elcont[xsd:sequence or xsd:choice or xsd:all]) 
          then
          ( let $se := $elcont/(xsd:sequence|xsd:choice|xsd:all)
            return local:procSequence(/,$se)
          )
          else if ($elcont[xsd:group]) 
          then
          ( let $gr := $elcont/(xsd:group)
            return local:procGroup(/,$gr)
          )
          else (),
          local:procAttributes(/,$elcont)
        }
    }
  }
  </xsd:complexType>
}

{ for $gr in //xsd:group[not(@ref)]
  let $name := if ($gr[@name]) 
               then $gr/@name 
               else local:createGroupName(/,$gr)
  return
  <xsd:group name="{$name}">
    { local:addAttributes(/,$gr),
      local:addAnnotation(/,$gr),
      let $grcont:= $gr/node()
      let $ctname:= $grcont/name()
      return
      if ($ctname="xsd:sequence" or $ctname="xsd:choice" or $ctname="xsd:all")
      then local:procSequence(/,$grcont)
      else ()
    }
  </xsd:group>
}

{ for $gr in //xsd:attributeGroup[not(@ref)]
  let $name := if ($gr[@name]) 
               then $gr/@name 
               else local:createAttributeGroupName(/,$gr)
  return
  <xsd:attributeGroup name="{$name}">
    { local:procAttributes(/,$gr) }
  </xsd:attributeGroup>
}

{ for $st in //xsd:simpleType[not(@ref)]
  let $name := if ($st[@name]) 
               then $st/@name else concat($st/../@name,'Type')
  let $def := $st/*
  return
    <xsd:simpleType name="{$name}">
      { $def }
    </xsd:simpleType>
}

{ for $el in //xsd:element[xsd:complexType or xsd:simpleType or @type]
  let $type := if ($el[@name and not(@type)]) 
               then concat($el/@name,'Type') else $el/@type
  return 
    <xsd:element name="{$el/@name}" type="{$type}">
      { local:addAttributesExceptMinAndMaxOccurs(/,$el),
        local:addAnnotation(/,$el) } 
    </xsd:element>
}

{ for $at in //xsd:attribute[xsd:simpleType or @type]
  let $type := if ($at[@name and not(@type)]) 
               then concat($at/@name,'Type') else $at/@type
  return 
    <xsd:attribute name="{$at/@name}" type="{$type}">
      { local:addAnnotation(/,$at) }
    </xsd:attribute>
} 
</xsd:schema>
