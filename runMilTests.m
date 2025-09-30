function runMilTests(modelFile)
    disp(['Running MIL tests for model: ', modelFile]);

    % Load the model
    load_system(modelFile);

    % Define expected test file (convention: modelName_Test.mldatx)
    [~, name, ~] = fileparts(modelFile);
    testFile = [name '_Test.mldatx'];

    if isfile(testFile)
        disp(['Test file found: ' testFile]);

        % Load test file into Simulink Test Manager
        sltest.testmanager.load(testFile);

        % Get test file object
        tfObj = sltest.testmanager.TestFile(testFile);

        % Get test suites from the test file
        suites = getTestSuites(tfObj);

        if isempty(suites)
            warning('No test suites found in test file. Skipping MIL tests.');
        else
            % Run the tests
            results = sltest.testmanager.run;
            reportFile = fullfile(pwd, [name '_Report.pdf']);
            sltest.testmanager.report(results, reportFile, ...
            'Author','sasi kakarla',...
            'IncludeMLVersion',true,...
           'IncludeTestResults', true, ...
           'IncludeSimulationSignalPlots', true, ...
           'IncludeTestResults',int32(0),...
           'IncludeComparisonSignalPlots', true,...
           'LaunchReport',true);
        end
    else
        warning(['No test file found for model ' modelFile '. Skipping MIL tests.']);
    end

    % Close the model
    close_system(modelFile, 0);
end
