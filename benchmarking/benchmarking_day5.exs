Application.ensure_all_started(:adventofcode2016)

Benchee.run(%{
  "naive part 1" => &Adventofcode2016.Solution.Day5.solve_part1/1,
  "naive part 2"=> &Adventofcode2016.Solution.Day5.solve_part2/1
  }, time: 60, parallel: 1, inputs: %{"abc" => "abc", "My input : cxdnnyjw"=> "cxdnnyjw"})