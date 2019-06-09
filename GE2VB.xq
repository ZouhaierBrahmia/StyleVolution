<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">

{ for $el in /xsd:schema/xsd:element
  where not(/xsd:schema/xsd:complexType/xsd:sequence/xsd:element[@ref=$el/@name])
  return $el
}

{ for $ct in /xsd:schema/xsd:complexType
  return
  <xsd:complexType name="{$ct/@name}">
    <xsd:sequence>
    { for $el in $ct/xsd:sequence/xsd:element
      let $ref := $el/@ref
      let $el1 := /xsd:schema/xsd:element[@name=$ref]
      let $ct1 := /xsd:schema/xsd:complexType[@name=$el1/@type]
      return
        if ($ct1)
        then 
        <xsd:element name="{$ref}" type="{$el1/@type}">
        { for $ea in $el/@*
          where name($ea)!="ref" and name($ea)!="type"
          return $ea
        }
        </xsd:element>
        else
        <xsd:element name="{$el1/@name}" type="{$el1/@type}">
        { for $ea in $el/@*
          where name($ea)!="ref" and name($ea)!="type"
          return $ea
        }
        </xsd:element>
    }
    </xsd:sequence>
    { for $at in $ct/xsd:attribute
      let $ref := $at/@ref
      let $el1 := /xsd:schema/xsd:attribute[@name=$ref]
      let $st1 := /xsd:schema/xsd:simpleType[@name=$el1/@type]
      return
        if ($st1)
        then 
        <xsd:attribute name="{$ref}" type="{$el1/@type}">
        { for $aa in $at/@*
          where name($aa)!="ref" and name($aa)!="type"
          return $aa
        }
        </xsd:attribute>
        else 
        <xsd:attribute name="{$el1/@name}" type="{$el1/@type}">
        { for $aa in $at/@*
          where name($aa)!="ref" and name($aa)!="type"
          return $aa
        }
        </xsd:attribute>
    }
  </xsd:complexType>
}

{ for $st in /xsd:schema/xsd:simpleType
  return $st
}

</xsd:schema>