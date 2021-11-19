classdef lateralcompressiontest < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        FileMenu                 matlab.ui.container.Menu
        OpenMenu                 matlab.ui.container.Menu
        SaveMenu                 matlab.ui.container.Menu
        SaveTheoreticalMenu      matlab.ui.container.Menu
        EditMenu                 matlab.ui.container.Menu
        ResetExperiementMenu     matlab.ui.container.Menu
        GraphMenu_2              matlab.ui.container.Menu
        AllMenu_2                matlab.ui.container.Menu
        ResetTheoryMenu          matlab.ui.container.Menu
        GraphMenu                matlab.ui.container.Menu
        AllMenu                  matlab.ui.container.Menu
        ResetComparisonMenu      matlab.ui.container.Menu
        AboutMenu                matlab.ui.container.Menu
        TabGroup                 matlab.ui.container.TabGroup
        ExperiementalResultsTab  matlab.ui.container.Tab
        YieldStressandYoungsModulusCalculationPanel  matlab.ui.container.Panel
        YieldStressExp           matlab.ui.control.NumericEditField
        yNmm2EditFieldLabel      matlab.ui.control.Label
        CALCULATEyEButton        matlab.ui.control.Button
        ThicknessExp             matlab.ui.control.NumericEditField
        ThicknessEditFieldLabel  matlab.ui.control.Label
        EGPaExp                  matlab.ui.control.NumericEditField
        EGPaEditFieldLabel       matlab.ui.control.Label
        Y2EditField              matlab.ui.control.NumericEditField
        Y2EditFieldLabel         matlab.ui.control.Label
        Y1EditField              matlab.ui.control.NumericEditField
        Y1EditFieldLabel         matlab.ui.control.Label
        X2EditField              matlab.ui.control.NumericEditField
        X2EditFieldLabel         matlab.ui.control.Label
        X1EditField              matlab.ui.control.NumericEditField
        X1EditFieldLabel         matlab.ui.control.Label
        ConversionPanel          matlab.ui.container.Panel
        PoEditField              matlab.ui.control.NumericEditField
        PoEditFieldLabel         matlab.ui.control.Label
        LengthExp                matlab.ui.control.NumericEditField
        LengthEditFieldLabel     matlab.ui.control.Label
        DiameterExp              matlab.ui.control.NumericEditField
        DiameterEditFieldLabel   matlab.ui.control.Label
        CALCULATEexpButton       matlab.ui.control.Button
        GraphAxisInputPanel      matlab.ui.container.Panel
        ForceDataY               matlab.ui.control.DropDown
        ForceYLabel              matlab.ui.control.Label
        DisplacementDataX        matlab.ui.control.DropDown
        DisplacementXLabel       matlab.ui.control.Label
        UIForceDispRadius        matlab.ui.control.UIAxes
        UIForceDisplacementEXP   matlab.ui.control.UIAxes
        TheoreticalResultsTab    matlab.ui.container.Tab
        HoldPlotTheoryCheckBox   matlab.ui.control.CheckBox
        Calculatetheory          matlab.ui.control.Button
        InputsPanel              matlab.ui.container.Panel
        lambdamin                matlab.ui.control.NumericEditField
        minLabel                 matlab.ui.control.Label
        lambdamax                matlab.ui.control.NumericEditField
        maxLabel                 matlab.ui.control.Label
        mREditField              matlab.ui.control.NumericEditField
        mREditFieldLabel         matlab.ui.control.Label
        UIForceDisplacementTHY   matlab.ui.control.UIAxes
        ResultComparisonTab      matlab.ui.container.Tab
        RadiusComp               matlab.ui.control.NumericEditField
        RmmEditFieldLabel        matlab.ui.control.Label
        thicknessComp            matlab.ui.control.NumericEditField
        tmmEditFieldLabel        matlab.ui.control.Label
        yieldstressComp          matlab.ui.control.NumericEditField
        oEditFieldLabel          matlab.ui.control.Label
        EpComp                   matlab.ui.control.NumericEditField
        EpEditFieldLabel         matlab.ui.control.Label
        NoteSelectmRValueforthebestfitwiththeexperimentalcurveLabel  matlab.ui.control.Label
        mRValueComp              matlab.ui.control.NumericEditField
        mRValueEditFieldLabel    matlab.ui.control.Label
        CalculateEpButton        matlab.ui.control.Button
        UICompare                matlab.ui.control.UIAxes
        StrainCalculationTab     matlab.ui.container.Tab
    end

    
    properties (Access = private)
        t % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app)
            
        end

        % Menu selected function: ResetExperiementMenu
        function ResetExperiementMenuSelected(app, event)
            
        end

        % Menu selected function: ResetTheoryMenu
        function ResetTheoryMenuSelected(app, event)
            
        end

        % Menu selected function: OpenMenu
        function OpenMenuSelected(app, event)
            [file, path] = uigetfile('*.xlsx; *.csv');
            if isequal(file,0)
                msgbox('Please input an Excel file','Error','error');
            else
                app.t = readtable(fullfile(path, file));
                app.DisplacementDataX.Items = app.t.Properties.VariableNames;
                app.ForceDataY.Items = app.t.Properties.VariableNames;
                
                plot(app.UIForceDisplacementEXP, app.t.(app.DisplacementDataX.Value), app.t.(app.ForceDataY.Value))
                
            end
        end

        % Value changed function: ForceDataY
        function ForceDataYValueChanged(app, event)
            value = app.ForceDataY.Value;
            
            plot(app.UIForceDisplacementEXP, app.t.(app.DisplacementDataX.Value), app.t.(app.ForceDataY.Value))
            
        end

        % Button pushed function: Calculatetheory
        function CalculatetheoryButtonPushed(app, event)
            mR = app.mREditField.Value;
            lmdmin = app.lambdamin.Value;
            lmdmax = app.lambdamax.Value;
            
            
            lambda = lmdmin:0.1:lmdmax;
            gamma = acos(1./lambda);
            n1 = mR*sqrt(lambda);
            n = 1  - (0.5/mR)^2;
            p = 0.707067812*(1-(n ./ lambda)).^0.5;
            phi = acos(1 ./(2*p.*n1));
            f = ellipticF(phi,p);
            e = ellipticE(phi, p);
            C = ((2.*e)-f)/n1;
            D = 2*(sin(gamma)-C);
            
           
            
            plot(app.UIForceDisplacementTHY, D, lambda);
            axis(app.UIForceDisplacementTHY, "auto")
            
            plot(app.UICompare,  D, lambda);
            
            app.mRValueComp.Value = mR;
            
                     
        end

        % Value changed function: DisplacementDataX
        function DisplacementDataXValueChanged(app, event)
            value = app.DisplacementDataX.Value;
            
            plot(app.UIForceDisplacementEXP, app.t.(app.DisplacementDataX.Value), app.t.(app.ForceDataY.Value))

        end

        % Value changed function: HoldPlotTheoryCheckBox
        function HoldPlotTheoryCheckBoxValueChanged(app, event)
            value = app.HoldPlotTheoryCheckBox.Value;
            
            switch value
                case 0
                    hold(app.UIForceDisplacementTHY, 'off');
                case 1
                    hold(app.UIForceDisplacementTHY, 'on');
            end
        end

        % Button pushed function: CALCULATEexpButton
        function CALCULATEexpButtonPushed(app, event)
            F = app.t.(app.ForceDataY.Value);
            L = app.LengthExp.Value;
            Po = app.PoEditField.Value;
            D = app.DiameterExp.Value;
            disp = app.t.(app.DisplacementDataX.Value);
            dbyR = disp/(D/2);
            FbyPo = F/(Po); 
            plot(app.UIForceDispRadius,dbyR, FbyPo);
            
            plot(app.UICompare,dbyR, FbyPo);
            hold(app.UICompare,"on");
            
            r = D/2;
            app.RadiusComp.Value = r;
            
        end

        % Button pushed function: CALCULATEyEButton
        function CALCULATEyEButtonPushed(app, event)
            L = app.LengthExp.Value;
            D = app.DiameterExp.Value;
            
            X1 = app.X1EditField.Value;
            X2 = app.X2EditField.Value;
            Y1 = app.Y1EditField.Value;
            Y2 = app.Y2EditField.Value;
            
            P = app.PoEditField.Value;
            
          
            TH = app.ThicknessExp.Value;
            
            
            app.EGPaExp.Value = ((pi/4)-(2/pi))*((12*(Y2-Y1)*((D/2)^3))/(L*(TH^3)*(X2-X1)));
            
            app.YieldStressExp.Value = ((P*(D/2))/(L*(TH^2)))*(1E3);
            
            
            app.thicknessComp.Value = TH;
            app.yieldstressComp.Value = app.YieldStressExp.Value;
            
        end

        % Menu selected function: SaveTheoreticalMenu
        function SaveTheoreticalMenuSelected(app, event)

        end

        % Menu selected function: GraphMenu_2
        function GraphMenu_2Selected(app, event)
            cla(app.UIForceDisplacementEXP)
            cla(app.UIForceDispRadius)
        end

        % Button pushed function: CalculateEpButton
        function CalculateEpButtonPushed(app, event)
            mR = app.mRValueComp.Value; 
            YS = app.yieldstressComp.Value;
            TH = app.thicknessComp.Value; 
            R = app.RadiusComp.Value;
            
            app.EpComp.Value = (6*YS)/(TH*R*mR^2);
            
        end

        % Menu selected function: ResetComparisonMenu
        function ResetComparisonMenuSelected(app, event)
            cla(app.UICompare);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 824 592];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.Resize = 'off';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Text = 'File';

            % Create OpenMenu
            app.OpenMenu = uimenu(app.FileMenu);
            app.OpenMenu.MenuSelectedFcn = createCallbackFcn(app, @OpenMenuSelected, true);
            app.OpenMenu.Text = 'Open';

            % Create SaveMenu
            app.SaveMenu = uimenu(app.FileMenu);
            app.SaveMenu.Text = 'Save';

            % Create SaveTheoreticalMenu
            app.SaveTheoreticalMenu = uimenu(app.SaveMenu);
            app.SaveTheoreticalMenu.MenuSelectedFcn = createCallbackFcn(app, @SaveTheoreticalMenuSelected, true);
            app.SaveTheoreticalMenu.Text = 'Save Theoretical';

            % Create EditMenu
            app.EditMenu = uimenu(app.UIFigure);
            app.EditMenu.Text = 'Edit';

            % Create ResetExperiementMenu
            app.ResetExperiementMenu = uimenu(app.EditMenu);
            app.ResetExperiementMenu.MenuSelectedFcn = createCallbackFcn(app, @ResetExperiementMenuSelected, true);
            app.ResetExperiementMenu.Text = 'Reset Experiement';

            % Create GraphMenu_2
            app.GraphMenu_2 = uimenu(app.ResetExperiementMenu);
            app.GraphMenu_2.MenuSelectedFcn = createCallbackFcn(app, @GraphMenu_2Selected, true);
            app.GraphMenu_2.Text = 'Graph';

            % Create AllMenu_2
            app.AllMenu_2 = uimenu(app.ResetExperiementMenu);
            app.AllMenu_2.Text = 'All';

            % Create ResetTheoryMenu
            app.ResetTheoryMenu = uimenu(app.EditMenu);
            app.ResetTheoryMenu.MenuSelectedFcn = createCallbackFcn(app, @ResetTheoryMenuSelected, true);
            app.ResetTheoryMenu.Text = 'Reset Theory';

            % Create GraphMenu
            app.GraphMenu = uimenu(app.ResetTheoryMenu);
            app.GraphMenu.Text = 'Graph';

            % Create AllMenu
            app.AllMenu = uimenu(app.ResetTheoryMenu);
            app.AllMenu.Text = 'All';

            % Create ResetComparisonMenu
            app.ResetComparisonMenu = uimenu(app.EditMenu);
            app.ResetComparisonMenu.MenuSelectedFcn = createCallbackFcn(app, @ResetComparisonMenuSelected, true);
            app.ResetComparisonMenu.Text = 'Reset Comparison';

            % Create AboutMenu
            app.AboutMenu = uimenu(app.UIFigure);
            app.AboutMenu.Text = 'About';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 13 803 580];

            % Create ExperiementalResultsTab
            app.ExperiementalResultsTab = uitab(app.TabGroup);
            app.ExperiementalResultsTab.Title = 'Experiemental Results';
            app.ExperiementalResultsTab.BackgroundColor = [0.902 0.902 0.902];

            % Create UIForceDisplacementEXP
            app.UIForceDisplacementEXP = uiaxes(app.ExperiementalResultsTab);
            xlabel(app.UIForceDisplacementEXP, 'Diplacement δ(mm)')
            ylabel(app.UIForceDisplacementEXP, 'Force P (kN)')
            app.UIForceDisplacementEXP.PlotBoxAspectRatio = [2.2280701754386 1 1];
            app.UIForceDisplacementEXP.FontWeight = 'bold';
            app.UIForceDisplacementEXP.Position = [357 317 428 226];

            % Create UIForceDispRadius
            app.UIForceDispRadius = uiaxes(app.ExperiementalResultsTab);
            xlabel(app.UIForceDispRadius, 'δ/R')
            ylabel(app.UIForceDispRadius, 'P/Po')
            app.UIForceDispRadius.PlotBoxAspectRatio = [2.2280701754386 1 1];
            app.UIForceDispRadius.FontWeight = 'bold';
            app.UIForceDispRadius.Position = [357 69 428 226];

            % Create GraphAxisInputPanel
            app.GraphAxisInputPanel = uipanel(app.ExperiementalResultsTab);
            app.GraphAxisInputPanel.Title = 'Graph Axis Input';
            app.GraphAxisInputPanel.FontWeight = 'bold';
            app.GraphAxisInputPanel.FontSize = 14;
            app.GraphAxisInputPanel.Position = [4 442 180 101];

            % Create DisplacementXLabel
            app.DisplacementXLabel = uilabel(app.GraphAxisInputPanel);
            app.DisplacementXLabel.HorizontalAlignment = 'right';
            app.DisplacementXLabel.FontWeight = 'bold';
            app.DisplacementXLabel.Position = [1 46 103 22];
            app.DisplacementXLabel.Text = 'Displacement (X)';

            % Create DisplacementDataX
            app.DisplacementDataX = uidropdown(app.GraphAxisInputPanel);
            app.DisplacementDataX.ValueChangedFcn = createCallbackFcn(app, @DisplacementDataXValueChanged, true);
            app.DisplacementDataX.FontWeight = 'bold';
            app.DisplacementDataX.Position = [119 46 50 22];

            % Create ForceYLabel
            app.ForceYLabel = uilabel(app.GraphAxisInputPanel);
            app.ForceYLabel.HorizontalAlignment = 'right';
            app.ForceYLabel.FontWeight = 'bold';
            app.ForceYLabel.Position = [46 14 58 22];
            app.ForceYLabel.Text = 'Force (Y)';

            % Create ForceDataY
            app.ForceDataY = uidropdown(app.GraphAxisInputPanel);
            app.ForceDataY.ValueChangedFcn = createCallbackFcn(app, @ForceDataYValueChanged, true);
            app.ForceDataY.FontWeight = 'bold';
            app.ForceDataY.Position = [119 14 50 22];

            % Create ConversionPanel
            app.ConversionPanel = uipanel(app.ExperiementalResultsTab);
            app.ConversionPanel.Title = 'Conversion ';
            app.ConversionPanel.FontWeight = 'bold';
            app.ConversionPanel.FontSize = 14;
            app.ConversionPanel.Position = [5 243 151 182];

            % Create CALCULATEexpButton
            app.CALCULATEexpButton = uibutton(app.ConversionPanel, 'push');
            app.CALCULATEexpButton.ButtonPushedFcn = createCallbackFcn(app, @CALCULATEexpButtonPushed, true);
            app.CALCULATEexpButton.BackgroundColor = [0.0745 0.6235 1];
            app.CALCULATEexpButton.FontWeight = 'bold';
            app.CALCULATEexpButton.Position = [26 16 100 22];
            app.CALCULATEexpButton.Text = 'CALCULATE';

            % Create DiameterEditFieldLabel
            app.DiameterEditFieldLabel = uilabel(app.ConversionPanel);
            app.DiameterEditFieldLabel.HorizontalAlignment = 'right';
            app.DiameterEditFieldLabel.FontWeight = 'bold';
            app.DiameterEditFieldLabel.Position = [12 128 57 22];
            app.DiameterEditFieldLabel.Text = 'Diameter';

            % Create DiameterExp
            app.DiameterExp = uieditfield(app.ConversionPanel, 'numeric');
            app.DiameterExp.FontWeight = 'bold';
            app.DiameterExp.Position = [84 128 50 22];
            app.DiameterExp.Value = 1;

            % Create LengthEditFieldLabel
            app.LengthEditFieldLabel = uilabel(app.ConversionPanel);
            app.LengthEditFieldLabel.HorizontalAlignment = 'right';
            app.LengthEditFieldLabel.FontWeight = 'bold';
            app.LengthEditFieldLabel.Position = [26 98 45 22];
            app.LengthEditFieldLabel.Text = 'Length';

            % Create LengthExp
            app.LengthExp = uieditfield(app.ConversionPanel, 'numeric');
            app.LengthExp.FontWeight = 'bold';
            app.LengthExp.Position = [86 98 48 22];
            app.LengthExp.Value = 1;

            % Create PoEditFieldLabel
            app.PoEditFieldLabel = uilabel(app.ConversionPanel);
            app.PoEditFieldLabel.HorizontalAlignment = 'right';
            app.PoEditFieldLabel.FontWeight = 'bold';
            app.PoEditFieldLabel.Position = [20 64 25 22];
            app.PoEditFieldLabel.Text = 'Po';

            % Create PoEditField
            app.PoEditField = uieditfield(app.ConversionPanel, 'numeric');
            app.PoEditField.FontWeight = 'bold';
            app.PoEditField.Position = [60 64 74 22];

            % Create YieldStressandYoungsModulusCalculationPanel
            app.YieldStressandYoungsModulusCalculationPanel = uipanel(app.ExperiementalResultsTab);
            app.YieldStressandYoungsModulusCalculationPanel.Title = 'Yield Stress and Young''s Modulus Calculation';
            app.YieldStressandYoungsModulusCalculationPanel.FontWeight = 'bold';
            app.YieldStressandYoungsModulusCalculationPanel.FontSize = 14;
            app.YieldStressandYoungsModulusCalculationPanel.Position = [6 11 325 207];

            % Create X1EditFieldLabel
            app.X1EditFieldLabel = uilabel(app.YieldStressandYoungsModulusCalculationPanel);
            app.X1EditFieldLabel.HorizontalAlignment = 'right';
            app.X1EditFieldLabel.FontWeight = 'bold';
            app.X1EditFieldLabel.Position = [11 149 25 22];
            app.X1EditFieldLabel.Text = 'X1';

            % Create X1EditField
            app.X1EditField = uieditfield(app.YieldStressandYoungsModulusCalculationPanel, 'numeric');
            app.X1EditField.FontWeight = 'bold';
            app.X1EditField.Position = [51 149 38 22];

            % Create X2EditFieldLabel
            app.X2EditFieldLabel = uilabel(app.YieldStressandYoungsModulusCalculationPanel);
            app.X2EditFieldLabel.HorizontalAlignment = 'right';
            app.X2EditFieldLabel.FontWeight = 'bold';
            app.X2EditFieldLabel.Position = [11 128 25 22];
            app.X2EditFieldLabel.Text = 'X2';

            % Create X2EditField
            app.X2EditField = uieditfield(app.YieldStressandYoungsModulusCalculationPanel, 'numeric');
            app.X2EditField.FontWeight = 'bold';
            app.X2EditField.Position = [51 128 38 22];

            % Create Y1EditFieldLabel
            app.Y1EditFieldLabel = uilabel(app.YieldStressandYoungsModulusCalculationPanel);
            app.Y1EditFieldLabel.HorizontalAlignment = 'right';
            app.Y1EditFieldLabel.FontWeight = 'bold';
            app.Y1EditFieldLabel.Position = [91 149 25 22];
            app.Y1EditFieldLabel.Text = 'Y1';

            % Create Y1EditField
            app.Y1EditField = uieditfield(app.YieldStressandYoungsModulusCalculationPanel, 'numeric');
            app.Y1EditField.FontWeight = 'bold';
            app.Y1EditField.Position = [131 149 38 22];

            % Create Y2EditFieldLabel
            app.Y2EditFieldLabel = uilabel(app.YieldStressandYoungsModulusCalculationPanel);
            app.Y2EditFieldLabel.HorizontalAlignment = 'right';
            app.Y2EditFieldLabel.FontWeight = 'bold';
            app.Y2EditFieldLabel.Position = [91 128 25 22];
            app.Y2EditFieldLabel.Text = 'Y2';

            % Create Y2EditField
            app.Y2EditField = uieditfield(app.YieldStressandYoungsModulusCalculationPanel, 'numeric');
            app.Y2EditField.FontWeight = 'bold';
            app.Y2EditField.Position = [131 128 38 22];

            % Create EGPaEditFieldLabel
            app.EGPaEditFieldLabel = uilabel(app.YieldStressandYoungsModulusCalculationPanel);
            app.EGPaEditFieldLabel.HorizontalAlignment = 'right';
            app.EGPaEditFieldLabel.FontWeight = 'bold';
            app.EGPaEditFieldLabel.Position = [5 16 49 22];
            app.EGPaEditFieldLabel.Text = 'E (GPa)';

            % Create EGPaExp
            app.EGPaExp = uieditfield(app.YieldStressandYoungsModulusCalculationPanel, 'numeric');
            app.EGPaExp.FontWeight = 'bold';
            app.EGPaExp.Position = [69 16 69 22];

            % Create ThicknessEditFieldLabel
            app.ThicknessEditFieldLabel = uilabel(app.YieldStressandYoungsModulusCalculationPanel);
            app.ThicknessEditFieldLabel.HorizontalAlignment = 'right';
            app.ThicknessEditFieldLabel.FontWeight = 'bold';
            app.ThicknessEditFieldLabel.Position = [12 90 64 22];
            app.ThicknessEditFieldLabel.Text = 'Thickness';

            % Create ThicknessExp
            app.ThicknessExp = uieditfield(app.YieldStressandYoungsModulusCalculationPanel, 'numeric');
            app.ThicknessExp.FontWeight = 'bold';
            app.ThicknessExp.Position = [91 90 100 22];

            % Create CALCULATEyEButton
            app.CALCULATEyEButton = uibutton(app.YieldStressandYoungsModulusCalculationPanel, 'push');
            app.CALCULATEyEButton.ButtonPushedFcn = createCallbackFcn(app, @CALCULATEyEButtonPushed, true);
            app.CALCULATEyEButton.BackgroundColor = [1 0.4118 0.1608];
            app.CALCULATEyEButton.FontWeight = 'bold';
            app.CALCULATEyEButton.Position = [91 48 129 22];
            app.CALCULATEyEButton.Text = 'CALCULATE σy & E';

            % Create yNmm2EditFieldLabel
            app.yNmm2EditFieldLabel = uilabel(app.YieldStressandYoungsModulusCalculationPanel);
            app.yNmm2EditFieldLabel.HorizontalAlignment = 'right';
            app.yNmm2EditFieldLabel.FontWeight = 'bold';
            app.yNmm2EditFieldLabel.Position = [152 16 72 22];
            app.yNmm2EditFieldLabel.Text = 'σy (N/mm2)';

            % Create YieldStressExp
            app.YieldStressExp = uieditfield(app.YieldStressandYoungsModulusCalculationPanel, 'numeric');
            app.YieldStressExp.FontWeight = 'bold';
            app.YieldStressExp.Position = [239 16 69 22];

            % Create TheoreticalResultsTab
            app.TheoreticalResultsTab = uitab(app.TabGroup);
            app.TheoreticalResultsTab.Title = 'Theoretical Results';

            % Create UIForceDisplacementTHY
            app.UIForceDisplacementTHY = uiaxes(app.TheoreticalResultsTab);
            xlabel(app.UIForceDisplacementTHY, 'δ/R')
            ylabel(app.UIForceDisplacementTHY, 'P/Po')
            app.UIForceDisplacementTHY.PlotBoxAspectRatio = [1.52029520295203 1 1];
            app.UIForceDisplacementTHY.FontWeight = 'bold';
            app.UIForceDisplacementTHY.YTick = [0 0.2 0.4 0.6 0.8 1];
            app.UIForceDisplacementTHY.Position = [164 207 492 326];

            % Create InputsPanel
            app.InputsPanel = uipanel(app.TheoreticalResultsTab);
            app.InputsPanel.Title = 'Inputs';
            app.InputsPanel.FontWeight = 'bold';
            app.InputsPanel.FontSize = 14;
            app.InputsPanel.Position = [9 409 127 132];

            % Create mREditFieldLabel
            app.mREditFieldLabel = uilabel(app.InputsPanel);
            app.mREditFieldLabel.HorizontalAlignment = 'right';
            app.mREditFieldLabel.FontWeight = 'bold';
            app.mREditFieldLabel.Position = [17 83 25 22];
            app.mREditFieldLabel.Text = 'mR';

            % Create mREditField
            app.mREditField = uieditfield(app.InputsPanel, 'numeric');
            app.mREditField.FontSize = 14;
            app.mREditField.FontWeight = 'bold';
            app.mREditField.Position = [50 83 55 22];

            % Create maxLabel
            app.maxLabel = uilabel(app.InputsPanel);
            app.maxLabel.HorizontalAlignment = 'right';
            app.maxLabel.FontSize = 14;
            app.maxLabel.FontWeight = 'bold';
            app.maxLabel.FontAngle = 'italic';
            app.maxLabel.Position = [1 16 45 22];
            app.maxLabel.Text = 'λ max';

            % Create lambdamax
            app.lambdamax = uieditfield(app.InputsPanel, 'numeric');
            app.lambdamax.FontSize = 14;
            app.lambdamax.FontWeight = 'bold';
            app.lambdamax.Position = [54 16 55 22];

            % Create minLabel
            app.minLabel = uilabel(app.InputsPanel);
            app.minLabel.HorizontalAlignment = 'right';
            app.minLabel.FontSize = 14;
            app.minLabel.FontWeight = 'bold';
            app.minLabel.FontAngle = 'italic';
            app.minLabel.Position = [4 49 42 22];
            app.minLabel.Text = 'λ min';

            % Create lambdamin
            app.lambdamin = uieditfield(app.InputsPanel, 'numeric');
            app.lambdamin.FontSize = 14;
            app.lambdamin.FontWeight = 'bold';
            app.lambdamin.Position = [54 49 55 22];

            % Create Calculatetheory
            app.Calculatetheory = uibutton(app.TheoreticalResultsTab, 'push');
            app.Calculatetheory.ButtonPushedFcn = createCallbackFcn(app, @CalculatetheoryButtonPushed, true);
            app.Calculatetheory.BackgroundColor = [0.0745 0.6235 1];
            app.Calculatetheory.FontWeight = 'bold';
            app.Calculatetheory.Position = [9 359 100 22];
            app.Calculatetheory.Text = 'CALCULATE';

            % Create HoldPlotTheoryCheckBox
            app.HoldPlotTheoryCheckBox = uicheckbox(app.TheoreticalResultsTab);
            app.HoldPlotTheoryCheckBox.ValueChangedFcn = createCallbackFcn(app, @HoldPlotTheoryCheckBoxValueChanged, true);
            app.HoldPlotTheoryCheckBox.Text = 'Hold Plot';
            app.HoldPlotTheoryCheckBox.FontWeight = 'bold';
            app.HoldPlotTheoryCheckBox.Position = [21 315 75 22];

            % Create ResultComparisonTab
            app.ResultComparisonTab = uitab(app.TabGroup);
            app.ResultComparisonTab.Title = 'Result Comparison';

            % Create UICompare
            app.UICompare = uiaxes(app.ResultComparisonTab);
            title(app.UICompare, 'Title')
            xlabel(app.UICompare, 'δ/R')
            ylabel(app.UICompare, 'P/Po')
            app.UICompare.PlotBoxAspectRatio = [2.84810126582278 1 1];
            app.UICompare.FontWeight = 'bold';
            app.UICompare.Position = [30 236 722 292];

            % Create CalculateEpButton
            app.CalculateEpButton = uibutton(app.ResultComparisonTab, 'push');
            app.CalculateEpButton.ButtonPushedFcn = createCallbackFcn(app, @CalculateEpButtonPushed, true);
            app.CalculateEpButton.BackgroundColor = [0.9294 0.6941 0.1255];
            app.CalculateEpButton.FontWeight = 'bold';
            app.CalculateEpButton.Position = [118 16 100 22];
            app.CalculateEpButton.Text = 'Calculate Ep';

            % Create mRValueEditFieldLabel
            app.mRValueEditFieldLabel = uilabel(app.ResultComparisonTab);
            app.mRValueEditFieldLabel.HorizontalAlignment = 'right';
            app.mRValueEditFieldLabel.FontWeight = 'bold';
            app.mRValueEditFieldLabel.Position = [83 153 60 22];
            app.mRValueEditFieldLabel.Text = 'mR Value';

            % Create mRValueComp
            app.mRValueComp = uieditfield(app.ResultComparisonTab, 'numeric');
            app.mRValueComp.Position = [158 153 65 22];

            % Create NoteSelectmRValueforthebestfitwiththeexperimentalcurveLabel
            app.NoteSelectmRValueforthebestfitwiththeexperimentalcurveLabel = uilabel(app.ResultComparisonTab);
            app.NoteSelectmRValueforthebestfitwiththeexperimentalcurveLabel.FontWeight = 'bold';
            app.NoteSelectmRValueforthebestfitwiththeexperimentalcurveLabel.Position = [30 190 383 22];
            app.NoteSelectmRValueforthebestfitwiththeexperimentalcurveLabel.Text = 'Note: Select mR Value for the best fit with the experimental curve';

            % Create EpEditFieldLabel
            app.EpEditFieldLabel = uilabel(app.ResultComparisonTab);
            app.EpEditFieldLabel.BackgroundColor = [0.302 0.7451 0.9333];
            app.EpEditFieldLabel.HorizontalAlignment = 'right';
            app.EpEditFieldLabel.FontSize = 14;
            app.EpEditFieldLabel.FontWeight = 'bold';
            app.EpEditFieldLabel.Position = [340 99 27 22];
            app.EpEditFieldLabel.Text = 'Ep ';

            % Create EpComp
            app.EpComp = uieditfield(app.ResultComparisonTab, 'numeric');
            app.EpComp.FontSize = 14;
            app.EpComp.FontWeight = 'bold';
            app.EpComp.BackgroundColor = [0.302 0.7451 0.9333];
            app.EpComp.Position = [382 99 100 22];

            % Create oEditFieldLabel
            app.oEditFieldLabel = uilabel(app.ResultComparisonTab);
            app.oEditFieldLabel.HorizontalAlignment = 'right';
            app.oEditFieldLabel.FontWeight = 'bold';
            app.oEditFieldLabel.Position = [118 120 25 22];
            app.oEditFieldLabel.Text = 'σo';

            % Create yieldstressComp
            app.yieldstressComp = uieditfield(app.ResultComparisonTab, 'numeric');
            app.yieldstressComp.Position = [158 120 65 22];

            % Create tmmEditFieldLabel
            app.tmmEditFieldLabel = uilabel(app.ResultComparisonTab);
            app.tmmEditFieldLabel.HorizontalAlignment = 'right';
            app.tmmEditFieldLabel.FontWeight = 'bold';
            app.tmmEditFieldLabel.Position = [101 88 42 22];
            app.tmmEditFieldLabel.Text = 't (mm)';

            % Create thicknessComp
            app.thicknessComp = uieditfield(app.ResultComparisonTab, 'numeric');
            app.thicknessComp.Position = [158 88 65 22];

            % Create RmmEditFieldLabel
            app.RmmEditFieldLabel = uilabel(app.ResultComparisonTab);
            app.RmmEditFieldLabel.HorizontalAlignment = 'right';
            app.RmmEditFieldLabel.FontWeight = 'bold';
            app.RmmEditFieldLabel.Position = [96 56 47 22];
            app.RmmEditFieldLabel.Text = 'R (mm)';

            % Create RadiusComp
            app.RadiusComp = uieditfield(app.ResultComparisonTab, 'numeric');
            app.RadiusComp.Position = [158 56 65 22];

            % Create StrainCalculationTab
            app.StrainCalculationTab = uitab(app.TabGroup);
            app.StrainCalculationTab.Title = 'Strain Calculation';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = lateralcompressiontest

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end