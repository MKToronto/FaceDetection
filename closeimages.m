function closeimages
% KILL  close all open figures and simulink models.
% Close all figures.
    % h=findall(0);
    % delete(h(2:end));
delete(findall(0,'Type','figure'))
% Close all Simulink models.
bdclose('all')