function [ TTable2Tlab ] = transformTable(TableEmre)



TTable2Tlab=rotZ(TableEmre(1))*rotY(TableEmre(2))*rotX(TableEmre(3))*transXYZ(TableEmre(4),TableEmre(5),TableEmre(6));




%TTable2Tlab=rotZ(Cyaw)*rotY(Cpitch)*rotZ(Croll)*transXYZ(Cx,Cy,Cz)
end
