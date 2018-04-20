{application, 'slager', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['slager','slager_app','slager_sup']},
	{registered, [slager_sup]},
	{applications, [kernel,stdlib,lager]},
	{mod, {slager_app, []}},
	{env, []}
]}.