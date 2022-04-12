/datum/emergency_call/marines
	name = "TGMC Reinforcements"
	base_probability = 11
	alignement_factor = 2
	///Number of current smartgunners in this squad.
	var/smartgunners
	///Max amount of smartgunners allowed in this squad.
	var/max_smartgunners = 1

/datum/emergency_call/marines/print_backstory(mob/living/carbon/human/H)
	to_chat(H, "<B>After leaving your [pick(75;"distant", 20;"close", 5;"ever-lovingly close")] [pick("family", "friends", "band of friends", "friend group", "relatives", "cousins")] [pick("behind", "behind in safety", "behind secretly", "behind regrettably")], you decided to join the ranks of a private military contracting group working for Nanotrasen.</b>")
	to_chat(H, "<B>Working there has proven to be [pick(50;"very", 20;"somewhat", 5;"astoundingly")] profitable for you.</b>")
	to_chat(H, "<B>While you are [pick("enlisted as", "officially", "part-time officially", "privately")] [pick("an employee", "a security officer", "an officer")], much of your work is off the books. You work as a skilled rapid-response contractor.</b>")
	to_chat(H, "")
	to_chat(H, "<B>Today, a fellow TGMC vessel, [SSmapping.configs[SHIP_MAP].map_name], has sent out a distress signal on the orbit of [SSmapping.configs[GROUND_MAP].map_name]. Your time is running short, get your shuttle launching!</b>")


/datum/emergency_call/marines/create_member(datum/mind/M)
	. = ..()
	if(!.)
		return

	var/mob/original = M.current
	var/mob/living/carbon/human/H = .

	M.transfer_to(H, TRUE)
	H.fully_replace_character_name(M.name, H.real_name)

	if(original)
		qdel(original)

	print_backstory(H)

	if(!leader)
		leader = H
		var/datum/job/J = SSjob.GetJobType(/datum/job/terragov/squad/leader)
		H.apply_assigned_role_to_spawn(J)
		to_chat(H, "<p style='font-size:1.5em'>[span_notice("You are a TGMC leader")]</p>")
		return

	if(prob(30))
		var/datum/job/J = SSjob.GetJobType(/datum/job/terragov/squad/smartgunner)
		H.apply_assigned_role_to_spawn(J)
		to_chat(H, "<p style='font-size:1.5em'>[span_notice("You are a TGMC smartgunner")]</p>")
		smartgunners++
		return

	if(prob(30))
		var/datum/job/J = SSjob.GetJobType(/datum/job/terragov/squad/corpsman)
		H.apply_assigned_role_to_spawn(J)
		to_chat(H, "<p style='font-size:1.5em'>[span_notice("You are a TGMC corpsman")]</p>")
		medics++
		return

	var/datum/job/J = SSjob.GetJobType(/datum/job/terragov/squad/standard)
	H.apply_assigned_role_to_spawn(J)
	to_chat(H, "<p style='font-size:1.5em'>[span_notice("You are a TGMC marine")]</p>")
