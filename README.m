[ct,Te,Ve,Xray]=Driver1('materials.mat'); % question 1

 [ct, Te, Ve, Xray]=Driver2( ct, Te, Ve, Xray ); % question 2
 %% I have a question re question2
 % Why not inverse transform? Double-check the wording
 
 %% question 3
 [ oX,oY,oZ ] = rigidTrans( ct, iPar);
 hold on;
 ts=150;
 plot3(oX(1:ts:end),oY(1:ts:end),oZ(1:ts:end),'.','Color','y');

plot3(oX(1),oY(1),oZ(1),'o','Color','k');
plot3(Xray.gridX(1),Xray.gridY(1),Xray.gridZ(1),'o','Color','k');
plot3(ct.gridX(1),ct.gridY(1),ct.gridZ(1),'o','Color','k');

%% question 4 - projection

