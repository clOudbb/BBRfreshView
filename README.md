# BBRfreshView

[![Language](https://img.shields.io/badge/language-oc-orange.svg?style=flat)](https://developer.apple.com/oc)

<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
</a>
<!-- <a href="https://codebeat.co/projects/github-com-xmartlabs-xlpagertabstrip"><img alt="codebeat badge" src="https://codebeat.co/badges/f32c9ad3-0aa1-4b40-a632-9421211bd39e" /></a> -->
</p>

* 对于biilibili下拉刷新的实现
* 由于collectionView并没有wrapperView，目前只可支持tableView

### Implementation

    - (BBRfreshView *)backGoundView
    {
        if (!_backGoundView) {
        _backGoundView = [BBRfreshView new ];
        _backGoundView.frame = self.tableView.frame;
        _backGoundView.backgroundColor = [UIColor clearColor];
    }
    return _backGoundView;
    }
    
    - (void)viewDidLoad {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backGoundView];
    [self.backGoundView showFromScrollView:self.tableView];
    self.backGoundView.showView.backgroundColor = [UIColor grayColor];
    }
    
### Requirements
* iOS 8+

### 具体效果
<img src="http://wx2.sinaimg.cn/mw690/005Duxwwgy1fj479gygiyg30ad0ijnbo.gif" width="25%" height="25%">
