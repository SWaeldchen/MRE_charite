if isempty(getenv('MREDGE_ENV_SET'))
    mredge_set_environment;
end
cd(getenv('MREDGE_DIR'))
cd ..
m2html('mfiles', 'MREdge', 'htmldir','MREdge/doc', 'recursive','on', ...
    'global','on', 'graph', 'on', 'ignoredDir', {'functions', 'compat'} );
cd MREdge