require('code-forensics').configure(
  {
    repository: {
      rootPath: "/repository"
    },
      excludePaths: [
        '**/target/*',
        '**/*.jar',
        '**/*.class',
        '**/node_modules'
      ]
    },
    {
        dateFrom: '2015-01-01',
        dateTo: '2018-06-30',
        targetFile: '/tmp/analysis'
    }
  
);
