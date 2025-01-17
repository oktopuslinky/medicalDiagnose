% Daily active hours
daily_time(7, 23).

% Facts for courses with days, times, and credit hours
% Ensures the starting and ending times comply with daily_time
course_time(calculus, monday_wednesday, 8, 0, 9, 30, 3) :- valid_course_time(8, 0, 9, 30).
course_time(physics, tuesday_thursday, 11, 0, 12, 30, 4) :- valid_course_time(11, 0, 12, 30).
course_time(computer_science, monday_wednesday, 14, 30, 16, 0, 3) :- valid_course_time(14, 30, 16, 0).
course_time(statistics, tuesday_thursday, 16, 0, 18, 0, 4) :- valid_course_time(16, 0, 18, 0).
course_time(discrete_maths, monday_wednesday, 10, 0, 11, 30, 3) :- valid_course_time(10, 0, 11, 30).

% Rule to validate course start and end times
valid_course_time(StartHour, StartMinute, EndHour, EndMinute) :-
    daily_time(StartLimit, EndLimit),
    StartMinute < 60,
    EndMinute < 60,
    StartHour < EndHour,
    StartHour >= StartLimit,
    EndHour =< EndLimit.

% Rule to calculate the gap between two courses on the same day
calculate_gap(Course1, Course2, GapHours, GapMinutes) :-
    course_time(Course1, Days1, _, _, EndHour1, EndMinute1, _),
    course_time(Course2, Days2, StartHour2, StartMinute2, _, _, _),
    Days1 = Days2, % Ensure the courses are on the same days
    not overlapping_courses(EndHour1, EndMinute1, StartHour2, StartMinute2),
    time_difference(EndHour1, EndMinute1, StartHour2, StartMinute2, GapHours, GapMinutes).

% Overlapping courses condition
overlapping_courses(EndHour1, EndMinute1, StartHour2, StartMinute2) :-
    (StartHour2 < EndHour1),
    (StartHour2 = EndHour1, StartMinute2 =< EndMinute1).

% Rule to calculate time difference
time_difference(EndHour1, EndMinute1, StartHour2, StartMinute2, GapHours, GapMinutes) :-
    TotalMinutes1 is EndHour1 * 60 + EndMinute1,
    TotalMinutes2 is StartHour2 * 60 + StartMinute2,
    GapMinutesTotal is TotalMinutes2 - TotalMinutes1,
    GapHours is GapMinutesTotal // 60,
    GapMinutes is mod(GapMinutesTotal, 60).

% Rule to calculate required study time for a course
study_time(Course, StudyHours) :-
    course_time(Course, _, _, _, _, _, CreditHours),
    StudyHours is CreditHours * 2.

%?- calculate_gap(calculus, computer_science, GapHours, GapMinutes).
%?- calculate_gap(physics, statistics, GapHours, GapMinutes).
%?- calculate_gap(calculus, discrete_maths, GapHours, GapMinutes).
%?- calculate_gap(physics, discrete_maths, GapHours, GapMinutes).
%?- study_time(calculus, StudyHours).
%?- study_time(physics, StudyHours).