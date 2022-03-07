function slider_test
% https://www.mathworks.com/matlabcentral/answers/347733-how-to-make-a-slider-gui-with-most-simple-code

FigH = figure('position',[360 500 400 400]);
axes('XLim', [0 4*pi], 'units','pixels', 'position',[100 50 200 200], 'NextPlot', 'add');

x     = linspace(0, 4*pi, 400);
y     = sin(x);
LineH = plot(x,y);
TextH = uicontrol('style','text','position',[170 340 40 15]);

SliderH = uicontrol('style','slider','position',[100 280 200 20], 'min', 0, 'max', 4*pi);
addlistener(SliderH, 'Value', 'PostSet', @callbackfn);
movegui(FigH, 'center')


function callbackfn(source, eventdata)
num          = get(eventdata.AffectedObject, 'Value');
LineH.YData  = sin(num * x);
TextH.String = num2str(num);
end

end





% https://www.mathworks.com/matlabcentral/answers/264979-continuous-slider-callback-how-to-get-value-from-addlistener#answer_207231
% A typical usage would be like this:
% addlistener(Handle, 'Value', 'PostSet',@MyCallBack);
% And note that while MyCallBack is a function, it does not have any output arguments. However when that function is called you can access the slider value very easily within that function.

% Here is a minimal example that simply displays the new value:
% MyCallBack = @(a,b) disp(get(b,'NewValue'));
% F = figure();
% H = uicontrol(F,'Style','slider');
% addlistener(H, 'Value', 'PostSet',MyCallBack);
% Again note that the new value is available inside the MyCallBack function workspace, so it is within this callback function that you need to use the new value as a variable. The easiest way is to write a new function just for the callback.

% Tip
% It would improve your code if you used guidata instead of using assignin:
% https://www.mathworks.com/help/matlab/creating_guis/share-data-among-callbacks.html
% https://www.mathworks.com/help/matlab/matlab_prog/share-data-between-workspaces.html