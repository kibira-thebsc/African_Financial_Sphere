#!/bin/bash
INPUT=index.html
OUTPUT=graph.gv

cat > $OUTPUT <<EOF
digraph G {
  #rankdir=LR;
  overlap=false
  splines=true
  tailclip=false
  headclip=false
EOF

cat $INPUT| grep -v "mastersection"| while read line; do
  if echo $line | grep -q "section id="; then
    # Page = Node
    SECTION=$(echo $line | cut -d'"' -f2)
    echo "_$SECTION [label=\"$SECTION\"]" >> $OUTPUT
  fi

  if echo $line | grep -qE "a href=\"#/"; then
    # Page = Node
    AHREF=$(echo $line | cut -d'"' -f2 | sed 's#\#/##g' )
    DESC=$(echo $line | cut -d'"' -f4 )
    echo "_$SECTION -> _$AHREF [label=\"$DESC\"]" >> $OUTPUT
  fi
done


cat >> $OUTPUT <<EOF
}
EOF

dot -Tpng $OUTPUT > graph.png
git add graph.gv graph.png
git status
