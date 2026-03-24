# 2026-03-25-outcome-quality-metrics

## What

I think it would be a good idea if during the ideation interview we have some sort of idea of whether or not the user accepts the recommendation, or if they don't, why they recommend why they choose something else. Or rather no. So if they accept the recommendation that's one thing. That's like a positive thing. If they choose something else, that's a somewhat mutual thing. It doesn't count towards rejection, I guess. But if they type something else, then it's should be considered like rejecting the plan unless they're adding more detail to the recommended option. And similarly, I think it would be good if, we could have some sort of match around Whether or not at the end of ideation or the end of implementation before a subject is done. Whether or not we change the existing plan. Retroactively. So like, something isn't right, you've got to make some adjustments. And so these are metrics for ideation and kanban that I would want to see. Optimized. By the optimized command. As potential metrics and maybe it's not specific to the kanban related skills, maybe it's just all skills, but what we're really after here is a way to judge the accuracy of the output according to the intent. I guess. Like, we would want to know hey, are we getting high quality output or low quality output which factors affect that, Like is it a persona throwing you off? Is it that you've led the conversation in the wrong direction? Is it that, Something else has gone wrong. Every time that something goes wrong, it would be great if we could record that and use that as part of the optimization loop and analysis so that we can over time produce better and better outcomes. I honestly don't really know how you would go about doing this. I only worry that all of our metrics at the moment are mid process or they're about the existing structure rather than the outcome. Of course, our existing metrics are also good, but we need something deterministic about whether or not we're improving our ability To produce high quality work,

[Agent clarified: current optimise metrics are structural (coverage, clarity, phase design) not outcome-based; suggested three signal sources — interview acceptance, plan drift via git history, and a deviation log per subject; noted the hypothesis that structural improvements should correlate with outcome improvements over time]

yes. do you have any ideas for /implement too? perhaps the number of times test fail or valid pr comments are risen, or maybe a pre-session-close rating?

[Agent clarified: suggested review cycle count (kanban bounce rate), scope violation rate, test failure at commit time rather than raw count, PR comment validity via existing review score/pass-fail, and a two-part session close — agent uncertainty log plus a lightweight user rating (yes/partially/no) written to the deviation log]

## Why

All of our metrics at the moment are mid process or they're about the existing structure rather than the outcome. We need something deterministic about whether or not we're improving our ability to produce high quality work.

## Constraints

Maybe it's not specific to the kanban related skills, maybe it's just all skills.

## Assets

None.

[Critic asked: where is the line between "adding detail to a recommendation" (neutral) and "rejecting and doing something else" (negative signal)?]

the agent will have to decide. i'll depend on whether the user extends one of the agent's suggestions or backtracks and changes the direction. e.g. Actually, ... or 'don't do that, instead' etc
